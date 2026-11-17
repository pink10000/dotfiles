import os
import re
import json
import curses
import sqlite3
import subprocess

def get_recent_projects():
    home = os.path.expanduser('~')
    path = os.path.join(home, '.config', 'Code', 'User', 'globalStorage', 'state.vscdb')

    if not os.path.exists(path):
        raise FileNotFoundError(f"Could not find the VSCode state file at {path}")

    conn = sqlite3.connect(f"file:{path}?mode=ro", uri=True)
    cursor = conn.cursor()

    cursor.execute("SELECT value FROM ItemTable WHERE key = 'history.recentlyOpenedPathsList'")
    row = cursor.fetchone()

    if row is None:
        return []

    data = json.loads(row[0])
    projects = data.get('entries', [])
    project_paths = []

    for entry in projects:
        if 'folderUri' in entry:
            project_paths.append(entry['folderUri'].replace('file://', ''))
        elif 'fileUri' in entry:
            project_paths.append(entry['fileUri'].replace('file://', ''))

    conn.close()
    return project_paths

def filter_projects(projects, query):
    query = query[:-1] if query and query[-1] == ' ' else query # remove trailing space if any
    
    return [proj for proj in projects if query.lower() in proj.lower()]

def main(stdscr):
    curses.curs_set(1)  # Show cursor
    curses.start_color()
    curses.use_default_colors()
    curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)

    projects = get_recent_projects()
    filtered_projects = projects
    current_row = 0
    search_query = ""

    while True:
        stdscr.erase()
        height, width = stdscr.getmaxyx()

        # Display search bar
        stdscr.addstr(0, 0, "Search: " + search_query)

        # Display project list
        for idx, project in enumerate(filtered_projects):
            x = 0
            y = idx + 1  # Start displaying projects below the search bar
            if y >= height - 1:
                break  # Prevent displaying beyond the terminal height
            if idx == current_row:
                stdscr.attron(curses.color_pair(1))
                stdscr.addstr(y, x, project[:width-1])
                stdscr.attroff(curses.color_pair(1))
            else:
                stdscr.addstr(y, x, project[:width-1])

        stdscr.refresh()

        key = stdscr.getch()

        if key == 27:  # ESC key
            subprocess.Popen(exit_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            break
        elif key == curses.KEY_UP and current_row > 0:
            current_row -= 1
        elif key == curses.KEY_DOWN and current_row < len(filtered_projects) - 1:
            current_row += 1
        elif key == curses.KEY_BACKSPACE or key == 127:
            search_query = search_query[:-1]
            filtered_projects = filter_projects(projects, search_query)
            current_row = 0
        elif key == ord('\n'):
            if filtered_projects:
                open_and_exit(filtered_projects[current_row])
                break
        elif 0 <= key <= 255:
            search_query += chr(key)
            filtered_projects = filter_projects(projects, search_query)
            current_row = 0

def open_project(project_path):
    subprocess.Popen(
        ['code', project_path, '--enable-features=UseOzonePlatform', '--ozone-platform=wayland'],
        start_new_session=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )

def open_and_exit(project_path):
    open_project(project_path)
    subprocess.Popen(exit_cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

def get_exit_cmd():
    """Return the hyprctl close-window command matching the installed Hyprland version."""
    try:
        out = subprocess.check_output(['hyprctl', 'version'], text=True, stderr=subprocess.DEVNULL)
        match = re.search(r'Hyprland\s+(\d+)\.(\d+)\.(\d+)', out)
        if match and tuple(map(int, match.groups())) >= (0, 55, 0):
            return ['hyprctl', 'dispatch', 'hl.dsp.window.close("kitty-rec")']
    except (subprocess.SubprocessError, OSError):
        pass
    return ['hyprctl', 'dispatch', 'closewindow', 'kitty-rec']

exit_cmd = get_exit_cmd()

if __name__ == "__main__":
    os.environ.setdefault('ESCDELAY', '25')
    curses.wrapper(main)

