import os
import json
import curses
import sqlite3
import subprocess
from urllib.parse import unquote

def get_recent_projects():
    home = os.path.expanduser('~')
    possible_paths = [
        os.path.join(home, '.vscode-shared', 'sharedStorage', 'state.vscdb'),
        os.path.join(home, '.vscode-oss-shared', 'sharedStorage', 'state.vscdb'),
        os.path.join(home, '.config', 'Code', 'User', 'globalStorage', 'state.vscdb'),
        os.path.join(home, '.config', 'VSCodium', 'User', 'globalStorage', 'state.vscdb'),
    ]

    project_paths = []
    for path in possible_paths:
        if not os.path.exists(path):
            continue
        try:
            conn = sqlite3.connect(path)
            cursor = conn.cursor()
            cursor.execute("SELECT value FROM ItemTable WHERE key = 'history.recentlyOpenedPathsList'")
            row = cursor.fetchone()
            conn.close()

            if row is not None:
                data = json.loads(row[0])
                projects = data.get('entries', [])
                for entry in projects:
                    path_str = None
                    if 'folderUri' in entry:
                        path_str = entry['folderUri']
                    elif 'fileUri' in entry:
                        path_str = entry['fileUri']
                    
                    if path_str:
                        clean_path = path_str.replace('file://', '')
                        clean_path = unquote(clean_path)
                        if clean_path not in project_paths:
                            project_paths.append(clean_path)
        except Exception:
            pass

    return project_paths

def filter_projects(projects, query):
    query = query[:-1] if query and query[-1] == ' ' else query # remove trailing space if any
    
    return [proj for proj in projects if query.lower() in proj.lower()]

def main(stdscr):
    try:
        curses.curs_set(1)  # Show cursor
    except curses.error:
        pass
    try:
        curses.start_color()
    except curses.error:
        pass
    try:
        curses.use_default_colors()
    except curses.error:
        pass
    try:
        curses.init_pair(1, curses.COLOR_BLACK, curses.COLOR_WHITE)
    except curses.error:
        pass

    projects = get_recent_projects()
    filtered_projects = projects
    current_row = 0
    search_query = ""

    while True:
        stdscr.clear()
        height, width = stdscr.getmaxyx()

        # Display search bar
        stdscr.addstr(0, 0, "Search: " + search_query)

        # Display project list
        if not filtered_projects:
            stdscr.addstr(2, 0, "No recent projects found.")
        else:
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
    try:
        subprocess.Popen(
            ['code', project_path, '--enable-features=UseOzonePlatform', '--ozone-platform=wayland'],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            start_new_session=True
        )
    except Exception:
        pass

def open_and_exit(project_path):
    open_project(project_path)

if __name__ == "__main__":
    curses.wrapper(main)

