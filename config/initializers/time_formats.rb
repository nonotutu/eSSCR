# Date (Year, Month, Day):
#   %Y - Year with century (can be negative, 4 digits at least)
#           -0001, 0000, 1995, 2009, 14292, etc.
#   %C - year / 100 (round down.  20 in 2009)
#   %y - year % 100 (00..99)
# 
#   %m - Month of the year, zero-padded (01..12)
#           %_m  blank-padded ( 1..12)
#           %-m  no-padded (1..12)
#   %B - The full month name (``January'')
#           %^B  uppercased (``JANUARY'')
#   %b - The abbreviated month name (``Jan'')
#           %^b  uppercased (``JAN'')
#   %h - Equivalent to %b
# 
#   %d - Day of the month, zero-padded (01..31)
#           %-d  no-padded (1..31)
#   %e - Day of the month, blank-padded ( 1..31)
# 
#   %j - Day of the year (001..366)
# 
# Time (Hour, Minute, Second, Subsecond):
#   %H - Hour of the day, 24-hour clock, zero-padded (00..23)
#   %k - Hour of the day, 24-hour clock, blank-padded ( 0..23)
#   %I - Hour of the day, 12-hour clock, zero-padded (01..12)
#   %l - Hour of the day, 12-hour clock, blank-padded ( 1..12)
#   %P - Meridian indicator, lowercase (``am'' or ``pm'')
#   %p - Meridian indicator, uppercase (``AM'' or ``PM'')
# 
#   %M - Minute of the hour (00..59)
# 
#   %S - Second of the minute (00..59)
# 
#   %L - Millisecond of the second (000..999)
#   %N - Fractional seconds digits, default is 9 digits (nanosecond)
#           %3N  millisecond (3 digits)
#           %6N  microsecond (6 digits)
#           %9N  nanosecond (9 digits)
#           %12N picosecond (12 digits)
# 
# Time zone:
#   %z - Time zone as hour and minute offset from UTC (e.g. +0900)
#           %:z - hour and minute offset from UTC with a colon (e.g. +09:00)
#           %::z - hour, minute and second offset from UTC (e.g. +09:00:00)
#           %:::z - hour, minute and second offset from UTC
#                                             (e.g. +09, +09:30, +09:30:30)
#   %Z - Time zone abbreviation name
# 
# Weekday:
#   %A - The full weekday name (``Sunday'')
#           %^A  uppercased (``SUNDAY'')
#   %a - The abbreviated name (``Sun'')
#           %^a  uppercased (``SUN'')
#   %u - Day of the week (Monday is 1, 1..7)
#   %w - Day of the week (Sunday is 0, 0..6)
# 
# ISO 8601 week-based year and week number:
# The week 1 of YYYY starts with a Monday and includes YYYY-01-04.
# The days in the year before the first week are in the last week of
# the previous year.
#   %G - The week-based year
#   %g - The last 2 digits of the week-based year (00..99)
#   %V - Week number of the week-based year (01..53)
# 
# Week number:
# The week 1 of YYYY starts with a Sunday or Monday (according to %U
# or %W).  The days in the year before the first week are in week 0.
#   %U - Week number of the year.  The week starts with Sunday.  (00..53)
#   %W - Week number of the year.  The week starts with Monday.  (00..53)
# 
# Seconds since the Unix Epoch:
#   %s - Number of seconds since 1970-01-01 00:00:00 UTC.
#   %Q - Number of microseconds since 1970-01-01 00:00:00 UTC.
# 
# Literal string:
#   %n - Newline character (\n)
#   %t - Tab character (\t)
#   %% - Literal ``%'' character
# 
# Combination:
#   %c - date and time (%a %b %e %T %Y)
#   %D - Date (%m/%d/%y)
#   %F - The ISO 8601 date format (%Y-%m-%d)
#   %v - VMS date (%e-%b-%Y)
#   %x - Same as %D
#   %X - Same as %T
#   %r - 12-hour time (%I:%M:%S %p)
#   %R - 24-hour time (%H:%M)
#   %T - 24-hour time (%H:%M:%S)
#   %+ - date(1) (%a %b %e %H:%M:%S %Z %Y)


Time::DATE_FORMATS[:cust_short]    = "%d/%m/%y - %H:%M"
Time::DATE_FORMATS[:cust_long]     = "%A %d %B %Y - %Hh%M"
Time::DATE_FORMATS[:cust_longdate] = "%A %d %B %Y"
Time::DATE_FORMATS[:cust_time]     = "%H:%M"
Time::DATE_FORMATS[:cust_date]     = "%d/%m/%y"
Time::DATE_FORMATS[:cust_jdate]    = "%A %d/%m/%y"
Time::DATE_FORMATS[:cust_jtime]    = "%A %H:%M"
Time::DATE_FORMATS[:cust_mmyy]     = "%m/%y"