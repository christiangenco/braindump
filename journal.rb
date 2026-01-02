#!/usr/bin/env ruby
# Write-only journaling app. Append-only to ~/journal.md.

require 'io/console'

JOURNAL_PATH = File.expand_path("~/journal.md")
TIMESTAMP_INTERVAL = 30 * 60 # 30 minutes in seconds

def write_line(text, session_start)
  now = Time.now
  elapsed = now - session_start

  File.open(JOURNAL_PATH, "a") do |f|
    if elapsed >= TIMESTAMP_INTERVAL
      timestamp = now.strftime("%Y-%m-%dT%H:%M:%S")
      f.write("\n## #{timestamp}\n\n")
      puts "\n\e[2m#{timestamp}\e[0m"
    end
    f.write("#{text}\n")
  end
end

def main
  session_start = Time.now
  timestamp = session_start.strftime("%Y-%m-%dT%H:%M:%S")

  File.open(JOURNAL_PATH, "a") { |f| f.write("\n## #{timestamp}\n\n") }

  puts "\e[2m#{timestamp}\e[0m"
  puts "\e[2mWrite-only journal. Ctrl+C or Ctrl+D to exit.\e[0m\n"

  line = ""

  STDIN.raw do |io|
    loop do
      ch = io.getc

      case ch
      when "\u0003", "\u0004" # Ctrl+C, Ctrl+D
        print "\r\n"
        break
      when "\r", "\n" # Enter
        print "\r\n"
        if line.length > 0
          write_line(line, session_start)
          session_start = Time.now
        end
        line = ""
      when "\u007F", "\b", "\u001b" # Backspace, Delete, Escape - ignore
        next
      else
        if ch.match?(/[[:print:]]/) || ch == "\t"
          line += ch
          print ch
        end
      end
    end
  end
end

main
