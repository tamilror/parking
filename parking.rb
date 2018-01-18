class Parking
  attr_accessor :reg_no, :color, :slot
  
  SLOTS=[]

  def initialize(inputs={})
    @slot = inputs[:slot] if inputs[:slot]
  end
  
  def assign_or_leave_slot(r_n=nil, clr=nil)
    self.reg_no = r_n
    self.color = clr
  end
  
  def self.create_parking_lot(num)
    (1..num.first.to_i).each{|n|
      SLOTS << Parking.new({slot: n})
    }
    puts "Created a parking lot with #{num.first} slots"
  end
  
  def self.park(inputs=[])
    r_n, clr = inputs[0], inputs[1]
    parking = SLOTS.detect{|s| s.reg_no.nil? }
    if parking
      parking.assign_or_leave_slot(r_n, clr)
      puts "Allocated slot number: #{parking.slot}"
    else
      puts "Sorry, parking lot is full"
    end
  end
  
  def self.leave(slot_no)
    parking = SLOTS.detect{|s| s.slot == slot_no.first.to_i }
    if parking
      parking.assign_or_leave_slot
      puts "Slot number #{slot_no.first} is free"
    else
      puts "Slot #{slot_no.first} Not found"
    end
  end
  
  def self.status(input=[])
    puts "Slot No.\tRegistration No \tColour"
    SLOTS.each{|s| 
      puts "#{s.slot.to_s.rjust(4)}\t#{s.reg_no.to_s.rjust(21)}\t#{s.color.to_s.rjust(13)}" if s.reg_no
    }
  end
  
  def self.registration_numbers_for_cars_with_colour(clr)
    result = SLOTS.collect{|s| s.color == clr.first ? s.reg_no : nil}.compact.join(", ")
    puts (result == "" ? "Result Not Found" : result)
  end

  def self.slot_numbers_for_cars_with_colour(clr)
    result = SLOTS.collect{|s| s.color == clr.first ? s.slot : nil}.compact.join(", ")
    puts (result == "" ? "Result Not Found" : result)
  end

  def self.slot_number_for_registration_number(r_no)
    result = SLOTS.collect{|s| s.reg_no == r_no.first ? s.slot : nil}.compact.join(", ")
    puts (result == "" ? "Result Not Found" : result)
  end

end

def execute_command(input)
  sliced_input = input.split(/\s/)
  command = sliced_input[0]
  if command 
    if Parking.methods.include?(command.to_sym)
      Parking.send(command, sliced_input-[command])
    else
      puts "Command not found"
    end
  end  
end

def process_input_file(input)
  input.split("\n").each do |input|
    execute_command(input)
  end
end

def main(again=false)
  if (ARGV.length == 0)
    if !again
      puts "Enter Command or 'exit' to finish:"
    end  
    inputs = gets
    inputs = inputs.chomp
    return if inputs && inputs.split(/\s/).first == "exit"
    execute_command(inputs)
    main(true)
  else
    begin
      input = File.read(ARGV[0])
    rescue StandardError => bang
      puts "Error reading file #{ bang }"
      return
    end
    begin
    process_input_file(input)
    rescue StandardError => bang
    puts "Error processing input. Error - #{ bang }"
    end
  end
end

main()
