require 'sinatra'

ExePath = "\"C:\\Program Files (x86)\\Microsoft SDKs\\Windows\\v10.0A\\bin\\NETFX 4.6 Tools\\ildasm.exe\""
MsBuild = "\"C:\\Program Files (x86)\\MSBuild\\14.0\\Bin\\MSBuild.exe\""

get "/" do 
  erb :index
end

post "/result" do
  @source = params["source"] 
  fp = File.open("in.cs", "w:utf-8")
  fp.write erb(:make_class)
  fp.close

  File.write "empty/empty/Program.cs", erb(:make_class)

  `#{MsBuild} empty\\empty.sln`
  `#{ExePath} /utf8 /text /out="r.html" /source /item:Program::Main empty/empty/bin/Debug/empty.exe`
  @il = File.read "r.html"

  erb :result
end