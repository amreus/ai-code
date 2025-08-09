#!/usr/bin/ruby
# rsync_log_parser.rb

class RsyncLogParser
  RsyncCodeExplanation = {
    'Y' => { # Update Type
      '<' => 'The file is being transferred to the remote host (sent).',
      '>' => 'The file is being transferred to the local host (received).',
      'c' => 'A local change or creation is occurring for the item (e.g., creating a directory or changing a symlink).',
      'h' => 'The item is a hard link to another item (requires --hard-links).',
      '.' => 'The item is not being updated, though its attributes might be modified.',
      '*' => 'The rest of the itemized-output area contains a message (e.g., "deleting").'
    },
    'X' => { # File Type
      'f' => 'Regular file.',
      'd' => 'Directory.',
      'L' => 'Symbolic link.',
      'D' => 'Device.',
      'S' => 'Special file (e.g., socket or FIFO).'
    },
    'c' => { # Checksum
      'c' => 'Checksum is different (requires --checksum), or a symlink, device, or special file has a changed value.',
      '.' => 'Checksum is unchanged.',
      '+' => 'Checksum is being set for a newly created item.'
    },
    's' => { # Size
      's' => 'Size of a regular file is different and will be updated.',
      '.' => 'Size is unchanged.',
      '+' => 'Size is being set for a newly created item.'
    },
    't' => { # Modification Time
      't' => 'Modification time is different and is being updated (requires --times).',
      '.' => 'Modification time is unchanged.',
      '+' => 'Modification time is being set for a newly created item.'
    },
    'p' => { # Permissions
      'p' => 'Permissions are different and are being updated (requires --perms).',
      '.' => 'Permissions are unchanged.',
      '+' => 'Permissions are being set for a newly created item.'
    },
    'o' => { # Owner
      'o' => 'Owner is different and is being updated (requires --owner and super-user privileges).',
      '.' => 'Owner is unchanged.',
      '+' => 'Owner is being set for a newly created item.'
    },
    'g' => { # Group
      'g' => 'Group is different and is being updated (requires --group and appropriate authority).',
      '.' => 'Group is unchanged.',
      '+' => 'Group is being set for a newly created item.'
    },
    'u' => { # Reserved for future use
      'u' => 'Reserved for future use.',
      '.' => 'Reserved for future use (unchanged).',
      '+' => 'Reserved for future use (being set for a newly created item).',
    },
    'a' => { # ACL information
      'a' => 'ACL information changed.',
      '.' => 'ACL information unchanged.',
      '+' => 'ACL information is being set for a newly created item.'
    },
    'x' => { # Extended attribute information
      'x' => 'Extended attribute information changed.',
      '.' => 'Extended attribute information unchanged.',
      '+' => 'Extended attribute information is being set for a newly created item.'
    }
  }

  def parse_log_file(file_path)
    File.foreach(file_path) do |line|
      # Regex to capture the 11-character code and the path, accounting for timestamp and process ID
      match = line.match(/^\d{4}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2} \[\d+\]\s+([<>ch.*.][fdLDS.][csptogua.+-]{9})\s+(.*)$/)
      if match
        code = match[1]
        path = match[2]
        explanation = explain_code(code)
        puts "\e[32m#{line.strip}\e[0m"
        puts "#{explanation}\n\n"
      end
    end
  end

  private

  def explain_code(code)
    explanation_parts = []

    # Y (Update Type)
    y_char = code[0]
    explanation_parts << RsyncCodeExplanation['Y'][y_char] if RsyncCodeExplanation['Y'].key?(y_char)

    # X (File Type)
    x_char = code[1]
    explanation_parts << RsyncCodeExplanation['X'][x_char] if RsyncCodeExplanation['X'].key?(x_char)

    # Attribute Changes (cstpoguax)
    attribute_chars = code[2..-1]
    attribute_keys = ['c', 's', 't', 'p', 'o', 'g', 'u', 'a', 'x']

    attribute_chars.each_char.with_index do |char, index|
      key = attribute_keys[index]
      if RsyncCodeExplanation[key] && RsyncCodeExplanation[key].key?(char)
        explanation_parts << RsyncCodeExplanation[key][char]
      end
    end

    explanation_parts.compact.join("\n")
  end
end

# Example Usage:
# To run this, save it as rsync_log_parser.rb
# Then, from your terminal, navigate to the directory containing the file and run:
# ruby rsync_log_parser.rb /path/to/your/dbak.log

if __FILE__ == $0
  if ARGV.empty?
    puts "Usage: ruby rsync_log_parser.rb <log_file_path>"
  else
    log_file = ARGV[0]
    if File.exist?(log_file)
      parser = RsyncLogParser.new
      parser.parse_log_file(log_file)
    else
      puts "Error: File not found at #{log_file}"
    end
  end
end
