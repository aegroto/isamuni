class Crawledsource < ApplicationRecord

  def self.from_fb_page page

    uid = page['id']

    if Crawledsource.exists?(uid: uid)
      source = Crawledsource.where(uid: uid).first
      source.touch
    else
      source = Crawledsource.new({
        uid: uid,
        name: page['name'],
      })
    end
    
    source
  end

end
