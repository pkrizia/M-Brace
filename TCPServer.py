from socket import *

# Ports from 0 to 1023 are reserved
serverPort = 12000
print('Server Port = ', serverPort)
serverSocket = socket(AF_INET, SOCK_STREAM)
serverSocket.bind(('', serverPort))
serverSocket.listen(1)
print('The server is ready to receive')
while(1):
	connectionSocket, addr = serverSocket.accept()
	sentence = connectionSocket.recv(1024)
	capitalizedSentence = sentence.upper()
	print(capitalizedSentence)
	connectionSocket.send(capitalizedSentence)
	connectionSocket.close()