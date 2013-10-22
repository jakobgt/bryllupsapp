watch /src\/.*\.haml/ do |md| `thor convert:haml` end
watch /src\/.*\.rb/ do |md| `thor convert:haml` end
watch /src\/.*\.scss/ do |md| `thor convert:sass` end
watch /src\/.*\.sass/ do |md| `thor convert:sass` end
watch /src\/.*\.css/ do |md| `thor convert:sass` end
watch /src\/.*\.coffee/ do |md| `thor convert:coffee` end
watch /src\/.*\.js/ do |md| `thor convert:coffee` end
watch /src\/.*\.png/ do |md| `thor convert:img` end

