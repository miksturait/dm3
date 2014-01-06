module DM2Import
  class Workload < Struct.new(:params)
    def process
      begin
        begin
          authenticate!
          import.import!
          import
        rescue => e
          # notify errbit
          something_went_wrong(e, import)
        end
      rescue => e
        something_went_wrong(e)
      end
    end

    private

    def authenticate!
      raise "wrong token" if auth_token != ENV["DM2_AUTH_TOKEN"]
    end

    def import
      @import ||=
          Work::TimeImport.new(coworker, time_entries_data)
    end

    def coworker
      Coworker.where(email: coworker_email).first!
    end

    def coworker_email
      params[:coworker_email]
    end

    def auth_token
      params[:auth_token]
    end

    def time_entries_data
      params[:time_entries_data]
    end

    def something_went_wrong(e, import=nil)
      (import || Work::TimeImport.new(nil, nil)).tap do |wti|
        wti.send(:clear_errors) if wti.errors.nil?
        wti.errors << e.to_s
        wti.errors << {params: params}.to_s
      end
    end
  end
end