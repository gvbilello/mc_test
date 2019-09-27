def checker(meetings)
  # create array of permutations of potential meeting orderings
  permutations = meetings.permutation.to_a

  # iterate through permutations and check each until a valid ordering is found
  permutations.each do |permutation|
    if check_if_valid(permutation)
      format_valid(permutation)
      break
    end
  end
end

def check_if_valid(meetings)
  hours = 8 # max hours in day

  meetings.each_with_index do |meeting, i|
    # evaluate travel time to meeting
    if i == 0
      travel_time = travel_time_to_meeting(nil, meeting[:type])
    else
      travel_time = travel_time_to_meeting(meetings[i - 1][:type], meeting[:type])
    end

    # deduct meeting duration and travel time from hours remaining in day
    hours -= (travel_time + meeting[:duration])
  end

  if hours >= 0
    # valid schedule only if 0 or more hours remaining
    return true
  end
end

def travel_time_to_meeting(prev_type, current_type)
  # travel time is 0 for first meeting of day or for 
  # onsite meetings when previous meeting was also onsite
  # otherwise, travel time is 0.5
  if prev_type.nil? || (prev_type == :onsite && current_type == :onsite)
    return 0
  else
    return 0.5
  end
end

def format_valid(meetings)
  start_time = 9 # day starts at 9:00 AM

  meetings.each_with_index do |meeting, i|
    # evaluate travel time to meeting
    if i == 0
      travel_time = travel_time_to_meeting(nil, meeting[:type])
    else
      travel_time = travel_time_to_meeting(meetings[i - 1][:type], meeting[:type])
    end

    # modify start_time to account for travel
    start_time += travel_time

    # set meeting end time
    end_time = start_time + meeting[:duration]

    puts "#{format_num_to_hour(start_time)} - #{format_num_to_hour(end_time)} - #{meeting[:name]}"

    start_time = end_time
  end
end

def format_num_to_hour(num)
  values = {
    "9.0" => "9:00",
    "9.5" => "9:30",
    "10.0" => "10:00",
    "10.5" => "10:30",
    "11.0" => "11:00",
    "11.5" => "11:30",
    "12.0" => "12:00",
    "12.5" => "12:30",
    "13.0" => "1:00",
    "13.5" => "1:30",
    "14.0" => "2:00",
    "14.5" => "2:30",
    "15.0" => "3:00",
    "15.5" => "3:30",
    "16.0" => "4:00",
    "16.5" => "4:30",
    "17.0" => "5:00"
  }

  # convert to float, the string to ensure valid entry is found in values hash
  str = num.to_f.round(1).to_s

  return values[str]
end

# test 1
m1 = [
  {:name => "Meeting 1", :duration => 3, :type => :onsite},
  {:name => "Meeting 2", :duration => 2, :type => :offsite},
  {:name => "Meeting 3", :duration => 1, :type => :offsite},
  {:name => "Meeting 4", :duration => 0.5, :type => :onsite}
]
# 9:00 - 12:00 - Meeting 1
# 12:30 - 2:30 - Meeting 2
# 3:00 - 4:00 - Meeting 3
# 4:30 - 5:00 - Meeting 4

# test 2
m2 = [
  {:name => "Meeting 1", :duration => 1.5, :type => :onsite},
  {:name => "Meeting 2", :duration => 2, :type => :offsite},
  {:name => "Meeting 3", :duration => 1, :type => :onsite},
  {:name => "Meeting 4", :duration => 1, :type => :offsite},
  {:name => "Meeting 5", :duration => 1, :type => :offsite}
]
# 9:00 - 10:30 - Meeting 1
# 10:30 - 11:30 - Meeting 3
# 12:00 - 2:00 - Meeting 2
# 2:30 - 3:30 - Meeting 4
# 4:00 - 5:00 - Meeting 5

# test 3
m3 = [
  {:name => "Meeting 1", :duration => 4, :type => :offsite},
  {:name => "Meeting 2", :duration => 4, :type => :onsite}
]
# Does not work

# test 4
m4 = [
  {:name => "Meeting 1", :duration => 0.5, :type => :offsite},
  {:name => "Meeting 2", :duration => 0.5, :type => :onsite},
  {:name => "Meeting 3", :duration => 2.5, :type => :offsite},
  {:name => "Meeting 4", :duration => 3, :type => :onsite}
]
# 9:00 - 9:30 - Meeting 1
# 10:00 - 10:30 - Meeting 2
# 11:00 - 1:30 - Meeting 3
# 2:00 - 5:00 - Meeting 4

# test 5 - max num of onsite meetings
m5 = [
  {:name => "Meeting 1", :duration => 1, :type => :onsite},
  {:name => "Meeting 2", :duration => 1, :type => :onsite},
  {:name => "Meeting 3", :duration => 1, :type => :onsite},
  {:name => "Meeting 4", :duration => 1, :type => :onsite},
  {:name => "Meeting 5", :duration => 1, :type => :onsite},
  {:name => "Meeting 6", :duration => 1, :type => :onsite},
  {:name => "Meeting 7", :duration => 1, :type => :onsite},
  {:name => "Meeting 8", :duration => 1, :type => :onsite}
]
# 9:00 - 10:00 - Meeting 1
# 10:00 - 11:00 - Meeting 2
# 11:00 - 12:00 - Meeting 3
# 12:00 - 1:00 - Meeting 4
# 1:00 - 2:00 - Meeting 5
# 2:00 - 3:00 - Meeting 6
# 3:00 - 4:00 - Meeting 7
# 4:00 - 5:00 - Meeting 8

# test 6 - max num of offsite meetings
m6 = [
  {:name => "Meeting 1", :duration => 1, :type => :offsite},
  {:name => "Meeting 2", :duration => 1, :type => :offsite},
  {:name => "Meeting 3", :duration => 1, :type => :offsite},
  {:name => "Meeting 4", :duration => 1, :type => :offsite},
  {:name => "Meeting 5", :duration => 1, :type => :offsite}
]
# 9:00 - 10:00 - Meeting 1
# 10:30 - 11:30 - Meeting 2
# 12:00 - 1:00 - Meeting 3
# 1:30 - 2:30 - Meeting 4
# 3:00 - 4:00 - Meeting 5

# checker(m1)
# checker(m2)
# checker(m3)
# checker(m4)
# checker(m5)
# checker(m6)
