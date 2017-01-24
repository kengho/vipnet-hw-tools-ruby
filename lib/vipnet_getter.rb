# encoding: UTF-8

class VipnetGetter
  ENTER_KEYCODE = 13
  PGDN_KEYCODE  = 34

  def self.iplirconf(params)
    hostname = params[:hostname]
    password = params[:password]
    username = params[:username] || "vipnet"
    output_file_path = params[:output_file_path]

    # Adding digest to "known_hosts" if needed.
    require "ruby_expect"
    exp_ssh_digest = RubyExpect::Expect.spawn("/usr/bin/ssh #{username}@#{hostname}")
    exp_ssh_digest.timeout = 3
    exp_ssh_digest.procedure do
      each do
        expect /Are you sure you want to continue connecting \(yes\/no\)\?\s*$/ do
          send "yes"
        end
      end
    end

    logged = false
    puts "Logging to #{username}@#{hostname}..."

    # "TERM=xterm" solves "WARNING: terminal is not fully functional" issue when running script with cron
    # TODO: test.
    exp = RubyExpect::Expect.spawn("TERM=xterm luit -encoding KOI8-R /usr/bin/ssh #{username}@#{hostname}")
    exp.timeout = 3
    iplirconf_content = ""
    exp.procedure do
      each do
        expect /password:\s*$/ do
          send password
          puts "Entering password..."
        end

        # For some reason, if password is incorrect, script waits for timeout
        # and don't expect ">" for "iplir show config".
        # Thus, commented code below doesn't work
        # expect /Permission denied, please try again/ do
        #   puts "permission denied"
        # end

        expect />\s*$/ do
          command = "iplir show config"
          send command
          puts command

          # When running with cron, message appears:
          # "WARNING: terminal is not fully functional
          # -  (press RETURN)"
          # So we imitate pressing <Enter>.
          send ENTER_KEYCODE
          logged = true
        end
      end
      return nil unless logged

      # Reading iplirconf until "default= .*" or /tunneldefault= .*/ lines appeared.
      # ("default" for vipnet v3 and "tunneldefault" for vipnet v4.)
      retflag = false
      while !retflag
        retval = any do
          expect /.*:/m do
            iplirconf_content << last_match.to_s
            last_match.to_s.split("\n").each do |line|
              if line =~ /^default=\s.*/ || line =~ /^tunneldefault=\s.*/
                retflag = true
                break
              end
            end
            send PGDN_KEYCODE
          end
        end
      end
    end

    # Encode and remove unsupported characters.
    iplirconf_content.force_encoding("UTF-8")
                     .gsub!("\r", "")
                     .gsub!(/[^\w\s\p{Cyrillic}=\(\)\[\]:\.\,@\#$%\^\-!]/, "")

    # Remove trash in the beginning.
    iplirconf_content.gsub!(/iplir show config.*1h=/m, "")
                     .gsub!("[7moptvipnetuseriplir.conf[27m[K[K:[K11[K33[K", "")

    # Remove trash in the middle.
    iplirconf_content.gsub!(/\[K\d+\[K\d+\[K/, "") # [K33[K44[K
    iplirconf_content.gsub!(/:\[K\[K:/, "") # :[K[K:

    # Remove trash in the end.
    iplirconf_content.gsub!(/\[7m\(END\).*\[K\[K:/, "")

    # Remove trailing spaces and add carriage return.
    iplirconf_content.strip!
    iplirconf_content << "\n\n"

    if output_file_path
      File.open(output_file_path, "w:KOI8-R") { |f| f.write(iplirconf_content) }
      output_file_path
    else
      require "tempfile"
      iplirconf_file = Tempfile.new("iplirconf", encoding: "KOI8-R")
      iplirconf_file.write(iplirconf_content)
      iplirconf_file.flush
      iplirconf_file.path
    end
  end
end
