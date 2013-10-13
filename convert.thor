ROOT = File.expand_path(File.dirname(__FILE__))
puts ROOT
class Convert < Thor
  desc "haml", "converts and puts haml in www"
  def haml
    `haml -r #{ROOT}/src/haml/helpers.rb #{ROOT}/src/haml/index.haml #{ROOT}/www/index.html`
 #   `haml -r #{ROOT}/src/haml/helpers.rb #{ROOT}/src/haml/pictures.haml #{ROOT}/www/pictures.html`
  end
  
  desc "sass", "converts and puts sass in www"
  def sass
    `sass --update #{ROOT}/src/sass:#{ROOT}/www/css`
    `cp #{ROOT}/src/css/* #{ROOT}/www/css/`
  end
  
  desc "coffee", "converts and puts coffeescript in www"
  def coffee
    `coffee -o #{ROOT}/www/js -c #{ROOT}/src/coffee`
    `cp #{ROOT}/src/js/* #{ROOT}/www/js/`
  end
  
  desc "all", "Convert haml, sass and coffee"
  def all
    invoke :haml
    invoke :sass
    invoke :coffee
  end
  
  desc "watch", "Start watchr to convert haml, sass and coffee source as it is modified"
  def watch
    invoke :all
    system "cd #{ROOT} && watchr tasks/converters.watchr"
  end
end
