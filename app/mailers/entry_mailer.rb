class EntryMailer < ActionMailer::Base
  helper.extend(ApplicationHelper)
  include FilepickerRails::ApplicationHelper

  def send_entry(user)
    @user = user
    @random_entry = user.random_entry(Time.now.in_time_zone(user.send_timezone).strftime("%Y-%m-%d"))
    @random_entry_filepicker_url = filepicker_image_url(@random_entry.image_url, w: 300, h: 300, fit: 'max', cache: true, rotate: :exif) if @random_entry.present? && @random_entry.image_url.present?
    @random_inspiration = random_inspiration

    headers['x-smtpapi'] = { :category => [ "Entry" ] }.to_json
    mail from: "Dabble Me <#{user.user_key}@#{ENV['SMTP_DOMAIN']}>",
         to: "#{user.full_name} <#{user.email}>",
         subject: "It's #{Time.now.in_time_zone(user.send_timezone).strftime("%A, %b %-d")} - How did your day go?"

    user.increment!(:emails_sent)
  end

  def import_finished(user, messages)
    @messages = messages
    mail from: "Dabble Me <hello@#{ENV['MAIN_DOMAIN']}>",
         to: "#{user.full_name} <#{user.email}>",
         subject: "OhLife Photo Import Complete"
  end

  def sent_report(total_sent_before, sent_this_session, sent_at)
    @total_sent_before = total_sent_before
    @sent_this_session = sent_this_session
    @total_sent_after = User.subscribed_to_emails.not_just_signed_up.sum(:emails_sent)
    headers['x-smtpapi'] = { :category => [ "Report" ] }.to_json
    mail from: "Dabble Me <hello+report@#{ENV['MAIN_DOMAIN']}>",
         to: "Dabble Me <hello+report@#{ENV['MAIN_DOMAIN']}>",
         subject: "Sent report for #{sent_at}"
  end

  private
    def random_inspiration
      if (count = Inspiration.without_ohlife_or_email.count) > 0
        Inspiration.without_ohlife_or_email.offset(rand(count)).first
      else
        nil
      end
    end

end