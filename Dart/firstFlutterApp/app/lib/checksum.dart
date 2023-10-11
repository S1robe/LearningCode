// true = TCP, false = UDP

enum HeaderType{
  udp, 
  dns, 
  icmp, 
  arp, 
  tcp, 
  ip, 
  ping,
}

extension HeaderValue on HeaderType {
  Map<String, int> get 
}




Map<String, int>? parseUDPHeader(List<int> header){
    final int fieldSize = 16; // each header field is 16 bits

    int ptrInHeader, totalLengthParsed;
    Map<String, int> parsedUDPHeader = {};
    Iterator<int> segmentIterator = header.iterator;
    while(segmentIterator.moveNext()) {
      int segment = segmentIterator.current;
      for(int bit in header){
        
      }
    }
    return parsedUDPHeader;
}


int checksum(boolean TCP, List<int> headerBytes) {
  if(TCP){
    


  }
}
