{ writePython3Bin, ... }:
writePython3Bin "rand-port"
  {
    libraries = [ ];
  }
  /* python */ ''
    import socket
    s = socket.socket()
    s.bind((''', 0))
    print(s.getsockname()[1])
    s.close()
  ''
