require 'mkmf'

glib_cflags   = %x{pkg-config --cflags  glib-2.0}.strip
glib_ldflags  = %x{pkg-config --libs    glib-2.0}.strip

if glib_cflags.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_INCLUDE_DIR env to override.}
  dirs = ENV.fetch('GLIB_INCLUDE_DIR', '/usr/include/glib-2.0 /usr/lib/glib-2.0/include')
  glib_cflags = dirs.split(/\s+/).map {|dir| "-I#{dir}"}.join(' ')
end

if glib_ldflags.empty?
  warn %q{WARNING: No pkg-config found for glib-2.0, using defaults. Set GLIB_LIB env to override.}
  libs = ENV.fetch('GLIB_LIB', 'glib-2.0')
  glib_ldflags = libs.split(/\s+/).map {|lib| "-l#{lib}"}.join(' ')
end

$CFLAGS  = glib_cflags   + %Q{ -Ilibots -I/usr/include/libxml2}
$LDFLAGS = glib_ldflags  + %Q{ -Llibots}

find_library('glib-2.0', 'main') or raise "unable to find glib-2.0"
find_library('xml2',     'main') or raise "unable to find libxml2"

# ugly mkmf hack: manually assign source and object directories.
$srcs = Dir["{libots/*.c,*.c}"]
$objs = $srcs.map {|name| File.join(File.dirname(name), File.basename(name, ".c") + ".o")}

class File
  def self.basename name
    name
  end
end

create_makefile 'ots'
