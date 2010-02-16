require 'mkmf'

$CFLAGS  = "-I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -Wall"
$LDFLAGS = "-lglib-2.0"

dir_config("libots", ["/usr/local", "/opt/local", "/usr"])

headers = [ 'stdio.h', 'stdlib.h', 'string.h', 'libots-1/ots/libots.h' ]
if have_header('libots-1/ots/libots.h') && have_library('ots-1', 'ots_new_article', headers)
  create_makefile 'ots'
else
  puts "Cannot find libots headers or libraries"
  exit 1
end
