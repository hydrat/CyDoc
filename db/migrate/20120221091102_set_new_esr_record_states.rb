class SetNewEsrRecordStates < ActiveRecord::Migration
  def self.up
    bad_records = EsrRecord.find(:all, :conditions => {:state => 'bad'})
    bad_records.map{|e|
      e.update_state
      e.save
    }
    EsrRecord.update_all("state = 'paid'", "state = 'valid'")
  end
end
