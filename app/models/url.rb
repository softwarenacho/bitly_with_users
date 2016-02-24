class Url < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  validates :url, presence: true
  validate :validate_url

  before_create :create_short_url

  def create_short_url
    self.short_url = shortener(self.url)
  end 

  def shortener(original)
    link = SecureRandom.urlsafe_base64(4)
    short_url = "#{link}"
  end

  def validate_url
    puts "ENTRE A VALIDATE"
    url = self.url
    puts "VALOR DE URL #{url}"
    if (url  =~ /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/) === nil
      puts "Error en validate"
      errors.add(:url, "Your URL is not valid")
    end
    puts "SALE DE VALIDATE"
  end

end