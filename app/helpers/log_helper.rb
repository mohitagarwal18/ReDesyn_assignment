module LogHelper
  class TailLogic 
    attr_accessor :filename, :fo, :mtime, :size

    def initialize(filename)
      @filename = filename
    end

    def update_status
      mtime = @fo.mtime
      size = @fo.size
    end

    def get_fo
      @fo ||= File.open(filename)
      update_status
    end

    def read(num=10)
      get_fo
      pos = 0
      curr_num = 1

      loop do
        pos -= 1
        fo.seek(pos, IO::SEEK_END)

        char = fo.read(1)

        if eol?(char)
          curr_num += 1
        end

        break if curr_num > num || fo.pos == 0
      end

      update_status
      fo.read
    end

    def read_latest
      update_status
      fo.read
    end

    def eol?(char)
      char == "\n"
    end

    def file_changed?
      size != fo.size || mtime != fo.mtime
    end
  end
end
