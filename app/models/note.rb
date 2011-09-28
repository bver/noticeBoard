class Note < ActiveRecord::Base
  belongs_to :board
  belongs_to :user
  has_many :changes, :dependent => :destroy

  validates_length_of :title, :minimum=> 3,  :maximum=>40
  
  def status
    return :active if self.outcome.nil?
    self.outcome ? :finished : :cancelled
  end

  def status=sym
    self.outcome = Note.status2outcome sym
  end

  def Note.status2outcome sym
    case sym.to_s[0].upcase
    when 'A'
      nil
    when 'F'
      true
    when 'C'
      false
    else
      raise ArgumentError
    end
  end

  def save_attachement(upload)
    return nil if upload.nil?
    #return nil unless /^image/ =~ upload['datafile'].content_type

    dir = "#{Rails.root}/public/attachements/#{self.id}"
    Dir.mkdir( dir ) unless FileTest.directory?( dir )

    name = upload['datafile'].original_filename
    File.open( File.join( dir, name ), "wb" ) { |f| f.write(upload['datafile'].read) }

    name
  end

  def time
    return nil if self.instant_time.nil?
    self.instant_time.to_s.split(' ')[1].gsub(/\:\d\d$/,'')
  end

  def time= value
    self.instant_time = value.nil? ? nil : Time.parse(value)
  end

  def date
    return nil if self.instant_date.nil?
    self.instant_date.to_s(:db).split(' ').first.split('-').reverse.join('.')
  end

  def date= value
    self.instant_date = value.nil? ? nil : Date.parse(value)
  end

end
