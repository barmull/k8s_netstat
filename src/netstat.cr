
module Netstat 
# kubectl exec cluster-tools-lhwkk -t -- nsenter -t 743858 -n netstat
# Active Internet connections (w/o servers)
# Proto Recv-Q Send-Q Local Address           Foreign Address         State      
# tcp        0      0 10.244.0.193:3306       10.244.0.194:36378      TIME_WAIT  
# tcp        0      0 10.244.0.193:3306       10.244.0.194:36680      TIME_WAIT  
# Active UNIX domain sockets (w/o servers)
# Proto RefCnt Flags       Type       State         I-Node   Path

  def self.remove_header(output)
    Log.info {"remove_header output: #{output}"}
    # get rid of headers and footers
    
    output_split = output.split("\n").compact
    no_header = output_split[2..(output_split.size - 3)] 
    Log.info {"parse no_header: #{no_header }"} 
    no_header 
  end

  def self.parse_line(no_header_output)
    Log.info {"parse no_header: #{no_header_output}"}
    status = no_header_output.map do |line| 
      parsed_line = line.split(/ +/)
      Log.info {"parsed_line: #{parsed_line}"}
      if parsed_line.size == 7 
        {
          proto: parsed_line[0],
          recv: parsed_line[1],
          send: parsed_line[2],
          local_address: parsed_line[3],
          foreign_address: parsed_line[4],
          state: parsed_line[5]
        }
      end
    end
    Log.info {"status: #{status.compact}"}
    status.compact
  end

  def self.parse(output) : Array(NamedTuple(proto: String, 
                                            recv: String, 
                                            send: String, 
                                            local_address: String, 
                                            foreign_address: String, 
                                            state: String))
    no_header = remove_header(output)
    parse_line(no_header)
  end
end
