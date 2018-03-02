from socket import *

# IP is the loopback address aka "localhost"
# Used to establish connection to the same machine/computer
serverName = '127.0.0.1'
serverPort = 12000
print('Server Port = ', serverPort)
print('Server Name = ', serverName)
clientSocket = socket(AF_INET, SOCK_STREAM)
clientSocket.connect((serverName, serverPort))
sentence = raw_input('Input lowercase sentence: ').encode()
clientSocket.send(sentence)
modifiedSentence = clientSocket.recv(1024)
print('From Server: ', modifiedSentence.decode())
clientSocket.close()