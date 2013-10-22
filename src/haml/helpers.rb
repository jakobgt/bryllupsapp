CURRENT_DIR = File.dirname(__FILE__)

def render(partial, &block)
  # assuming we want to keep the rails practice of prefixing file names
  # of partials with "_"
  Haml::Engine.new(File.read(File.join(CURRENT_DIR,"_#{partial}.html.haml"))).render(
     Object.new, {}, &block)
end

def navigation(heading)
  # assuming we want to keep the rails practice of prefixing file names
  # of partials with "_"
  Haml::Engine.new(File.read(File.join(CURRENT_DIR,"_navigation.html.haml"))).render(
     Object.new, heading: heading)
end

