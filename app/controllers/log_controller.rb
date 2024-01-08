class LogController < ApplicationController
  include ActionController::Live

  def log
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers["Last-Modified"] = Time.now.httpdate

    file = LogHelper::TailLogic.new(Rails.root.join("log/development.log"))

    response.stream.write file.read

    loop do
      if file.file_changed?
        response.stream.write file.read_latest
      end
      sleep 0.2
    end
  ensure 
    response.stream.close
  end
end
