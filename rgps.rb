require 'gtk3'

def on_treeview_cursor_changed
#  p "on_treeview_cursor_changed"
  return if @treeview.selection.selected.nil?
#    p "selected"
  iter = @treeview.selection.selected
#    p "---cur---", iter[0], iter[1], iter[2]
  @textbuf.text = ''
  begin
    File.open(iter[2], 'r') do |desc_file|
      desc_file.each_line do |line|
        @textbuf.text = @textbuf.text + line
      end
    end
  rescue
    @textbuf.text = "cannot open #{iter[2]}"
  end
end

#def on_search_changed
#  p @searchentry.buffer.text
#end

def on_searchentry_activate
#  p @searchentry.buffer.text
  @treeview.selection.unselect_all
  @treeview.selection.mode = :none
  if @searchentry.buffer.text.match(/\w+/).nil?
    @searchentry.buffer.text = ''
    @list.clear
    fill_list
  else
    update_list(@searchentry.buffer.text)
  end
    @treeview.selection.mode = :single
  @textbuf.text = ''
end

def add_columns(name, index)
  renderer = Gtk::CellRendererText.new
  column = Gtk::TreeViewColumn.new(name, renderer, 'text' => index)
  column.set_sort_column_id(index)
  column.set_resizable(true)
  column.set_max_width(220)
  @treeview.append_column(column)
end

def update_list(keyword)
  @list.clear
  File.open(@indexfile, 'r') do |file|
    file.each_line do |line|
      if /(?<name>[^|]+)\|(?<origin>[^|]+)\|(?<prefix>[^|]+)\|(?<desc>[^|]*)\|(?<descpath>[^|]+)\|(?<maintainer>[^|]+)\|(?<categories>[^|]+)/ =~ line
        if name.match?(/#{keyword}/i) || desc.match?(/#{keyword}/i)
          iter = @list.append
          iter[0] = name
          iter[1] = desc
          iter[2] = descpath
        end
      end
    end
  end
end

def fill_list
  File.open(@indexfile, 'r') do |file|
    file.each_line do |line|
      if /(?<name>[^|]+)\|(?<origin>[^|]+)\|(?<prefix>[^|]+)\|(?<desc>[^|]*)\|(?<descpath>[^|]+)\|(?<maintainer>[^|]+)\|(?<categories>[^|]+)/ =~ line
        iter = @list.append
        #      iter[0] = origin.gsub('/usr/ports/','')
        iter[0] = name
        iter[1] = desc
        iter[2] = descpath
      end
    end
  end
end

builder = Gtk::Builder.new(file: 'rgps.glade')

win = builder.get_object('win')
@treeview = builder.get_object('treeview')
@list = builder.get_object('list')
@textbuf = builder.get_object('textbuf')
@searchentry = builder.get_object('searchentry')

ver = `uname -r`
if /(?<major>\d+)\.(?<minor>\d+)/ =~ ver
  exit(-1) if major.nil?
end
@indexfile = '/usr/ports/INDEX-' + major
fill_list

add_columns('名称', 0)
add_columns('説明', 1)

win.signal_connect('destroy') { Gtk.main_quit }
builder.connect_signals { |handler| method(handler) }

win.show_all
Gtk.main
