import imaplib
obj = imaplib.IMAP4_SSL('imap.gmail.com',993)
# get your passored from here : https://myaccount.google.com/apppasswords
obj.login('youremail@gmail.com','password')
obj.select()
print(len(obj.search(None, 'UnSeen')[1][0].split()))