# encoding: UTF-8

namespace :customer do
  desc 'Carrega formas de contato padrões'
  task :load_default_data => :environment do
    ['E-mail', 'Telefone', 'Correspondência'].each do |contact_form|
      ContactForm.create(:name => contact_form)
    end
  end

  namespace :email do
    desc <<-END_DESC
Read emails from an IMAP server, create users but do not notifying them.

General options:
  unknown_user=ACTION      how to handle emails from an unknown user
                           ACTION can be one of the following values:
                           ignore: email is ignored (default)
                           accept: accept as anonymous user
                           create: create a user account but do not notificate user
                           customer: create a customer
                           notify: create a user account
        

Available IMAP options:
  host=HOST                IMAP server host (default: 127.0.0.1)
  port=PORT                IMAP server port (default: 143)
  ssl=SSL                  Use SSL? (default: false)
  username=USERNAME        IMAP account
  password=PASSWORD        IMAP password
  folder=FOLDER            IMAP folder to read (default: INBOX)
  
Issue attributes control options:
  project=PROJECT          identifier of the target project
  status=STATUS            name of the target status
  tracker=TRACKER          name of the target tracker
  category=CATEGORY        name of the target category
  priority=PRIORITY        name of the target priority
  allow_override=ATTRS     allow email content to override attributes
                           specified by previous options
                           ATTRS is a comma separated list of attributes
                           
Processed emails control options:
  move_on_success=MAILBOX  move emails that were successfully received
                           to MAILBOX instead of deleting them
  move_on_failure=MAILBOX  move emails that were ignored to MAILBOX
  
Examples:
  # No project specified. Emails MUST contain the 'Project' keyword:
  
  rake redmine:email:receive_iamp RAILS_ENV="production" \\
    host=imap.foo.bar username=redmine@example.net password=xxx


  # Fixed project and default tracker specified, but emails can override
  # both tracker and priority attributes:
  
  rake redmine:email:receive_iamp RAILS_ENV="production" \\
    host=imap.foo.bar username=redmine@example.net password=xxx ssl=1 \\
    project=foo \\
    tracker=bug \\
    allow_override=tracker,priority
END_DESC
    task :receive_imap => :environment do
      if ENV['unknown_user'] == 'create'
        turn_off_mailer
      end

      if ENV['unknown_user'] == 'customer'
        turn_off_mailer
        turn_on_customer_creation
      end

      if ENV['unknown_user'] == 'notify'
        ENV['unknown_user'] = 'create'
      end

      Rake::Task['redmine:email:receive_imap'].invoke
    end
  end
end

def turn_on_customer_creation
  class << MailHandler
    def create_user_from_email(email)
      Customer.from_email(email)
      nil #so he doesn't think we created an user
    end
  end
end

def turn_off_mailer
  class << Mailer
    def deliver_account_information(user, password)
      logger.info "Customer::Email: Preventing an email to be sent to user #{user}" if logger && logger.info
    end
  end
end

