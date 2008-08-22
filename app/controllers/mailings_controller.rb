class MailingsController < ApplicationController
  # Authorization
  # =============
  before_filter :authorize, :except => [:list, :index, :latest_overview]
  private
  def authorize
    begin
      Mailing.find(params[:id], :conditions => { :doctor_id => @current_doctor_ids})
    rescue ActiveRecord::RecordNotFound
      render :partial => 'shared/access_denied', :status => 404
    end
  end

  # Actions
  # =======
  public
  def index
    redirect_to :action => :latest_overview
  end
  
  def latest_overview
    @open_cases = Case.find(:all, :conditions => ['result_report_printed_at = ? AND doctor_id IN (?) AND examination_date > ?', nil, @current_doctor_ids, '2008-01-01'])

    @mailing = Mailing.find(:first, :order => 'printed_at DESC', :conditions => {:doctor_id => @current_doctor_ids})
    @older_mailings = Mailing.find(:all, :order => 'printed_at DESC', :conditions => {:doctor_id => @current_doctor_ids}, :limit => 10)
  end

  def overview
    @mailing = Mailing.find(params[:id])
    @older_mailings = Mailing.find(:all, :order => 'printed_at DESC', :conditions => {:doctor_id => @current_doctor_ids}, :limit => 10)
  end

  def overview_inline
    overview
    render :action => 'overview', :layout => false
  end

  def list
    @mailings = Mailing.find(:all, :order => 'printed_at DESC', :conditions => {:doctor_id => @current_doctor_ids}, :limit => 10)
  end
end
