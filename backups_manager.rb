require 'date'

directory_path = ARGV[0]

Dir.foreach(directory_path) do |dirname|

    # ignore system files
    next if dirname == '.' or dirname == '..'

    Dir.foreach("#{directory_path}/#{dirname}") do |filename|

        # ignore system files
        next if filename == '.' or filename == '..'

        print filename

        # retrieve date from file name
        year, month, day, hours_and_minutes = filename.split('-').last(4)
        hours_and_minutes = hours_and_minutes.split('.')[0]
        hours = hours_and_minutes[0..-3]
        minutes = hours_and_minutes[2..-1]
        time = Time.new(year, month, day, hours, minutes, 0)

        # backups created during the last 24 hours should be kept
        very_recent_param = (time.to_i > (Time.now.to_i - 86400))

        # backups created during the last week and at midnight should be kept
        one_per_day_param = time.hour === 0 && (time.to_i > (Time.now.to_i - 604800))

        # backups created during the last month and a sunday should be kept
        one_per_week_param = time.hour === 0 && time.sunday? && (time.to_i > (Time.now.to_i - 2678400))

        # backups created during the last year and the first of the month should ke kept
        one_per_month_param = time.day === 1 && (time.to_i > (Time.now.to_i - 31622400))
        
        # backups the file
        unless very_recent_param || one_per_day_param || one_per_week_param || one_per_month_param
            File.delete "#{directory_path}/#{dirname}/#{filename}"
            print "#{filename} deleted.\n"
        else
            print "#{filename} kept.\n"
        end

    end

end
