extends Panel

var MemoryTest = []
var MembersToAppend = 10000000
var VelocityToAppend = 100000

var ActualAppend = 0
var NODE_Console
var NODE_Append_Button
var NODE_MembersToAppend_LineEdit
var NODE_Velocity_LineEdit
var NODE_Clear_Button
var NODE_ShowMembers_Label
var NODE_Button_Stop
var NODE_To_Crash

var ToCrash=false

func _ready():
	
	NODE_Console = get_node("VB/Console")
	
	NODE_Append_Button = get_node("VB/HBoxContainer/Append")
	NODE_Append_Button.connect("pressed", self, "_button_append_pressed")
	
	NODE_MembersToAppend_LineEdit = get_node("VB/HBoxContainer/MembersToAppend")
	NODE_MembersToAppend_LineEdit.connect("text_changed", self, "_members_to_append_text_changed")
	
	NODE_Velocity_LineEdit = get_node("VB/HBoxContainer/Velo")
	NODE_Velocity_LineEdit.connect("text_changed",self, "_velocity_changed")

	NODE_Clear_Button = get_node("VB/HBoxContainer/Clear")
	NODE_Clear_Button.connect("pressed", self, "_button_clear_array_pressed")

	NODE_ShowMembers_Label = get_node("VB/HBoxContainer/NumMembers")
	
	NODE_Button_Stop = get_node("VB/HBoxContainer2/Stop")
	NODE_Button_Stop.connect("pressed", self, "_button_stop_pressed")
	
	NODE_To_Crash = get_node("VB/HBoxContainer2/ToCrash")
	NODE_To_Crash.connect("toggled", self, "_to_crash_toggled")
	
	set_process(false)

func _to_crash_toggled(Activated):
	if Activated: ToCrash = true
	else: ToCrash = false

func _button_append_pressed():
	ActualAppend = MembersToAppend
	set_process(true)

func _button_stop_pressed():
	set_process(false)

func _button_clear_array_pressed():
	MemoryTest.clear()

func _members_to_append_text_changed(newtext):
	if newtext.is_valid_float():
		MembersToAppend = float(newtext)
	else: print ("not valid float")
	
func _velocity_changed(newtext):
	if newtext.is_valid_float():
		VelocityToAppend = float(newtext)
	else: print ("not valid float")

func _process(delta):
	if ActualAppend >0:
		var ActualLoopAppend = round(VelocityToAppend) #it should be multiplied by delta but this make differences between entered number of iterations and final iterations
		while ActualLoopAppend >0:
			MemoryTest.append(0)
			ActualLoopAppend -= 1
			ActualAppend -= 1
	else: 
		if ToCrash:
			ActualAppend = MembersToAppend
		else:
			ActualAppend = 0
			print ("End")
			set_process(false)

func _physics_process(delta):
	NODE_ShowMembers_Label.text = str(MemoryTest.size())
	actualize_console()

func actualize_console():
	NODE_Console.clear()
	NODE_Console.push_color(Color.cyan)
	NODE_Console.append_bbcode("Please open task manager to compare real memory allocated by godot, can differ from OS.get_static_memory_usage()")
	NODE_Console.pop()
	NODE_Console.newline()
	NODE_Console.newline()
	NODE_Console.append_bbcode("Array Members (All are 0): "+get_int_with_dots(MemoryTest.size()))
	NODE_Console.newline()
	NODE_Console.append_bbcode("Operating System Static Memory: "+ get_int_with_dots(int(OS.get_static_memory_usage()/1000)) +" KB")
	NODE_Console.newline()
	if MemoryTest.size() >= 41000000:
		NODE_Console.push_color(Color.green)
		NODE_Console.append_bbcode("We are reached aprox 1GB of memory")
		NODE_Console.pop()
		NODE_Console.newline()
	if OS.get_static_memory_usage() < 0:
		NODE_Console.push_color(Color.red)
		NODE_Console.append_bbcode("Well.... OS.get_static_memory_usage is reporting a negative number... probably you are up to 1.2GB")
		NODE_Console.pop()
		NODE_Console.newline()
	if MemoryTest.size() >= 80000000:
		NODE_Console.push_color(Color.green)
		NODE_Console.append_bbcode("Godot it´s reaching 2 GB aprox and probably crash")
		NODE_Console.pop()
		NODE_Console.newline()
	if MemoryTest.size() >= 89000000:
		NODE_Console.push_color(Color.red)
		NODE_Console.append_bbcode("Danger.... probably you are at 2.1Gb if 2.2 GB reached  WILL CRASH!!!")
		NODE_Console.pop()
		NODE_Console.newline()
	if MemoryTest.size() >= 100000000:
		NODE_Console.push_color(Color.blue)
		NODE_Console.append_bbcode("CONGRATULATIONS... you have past the test, please report what did you do to not crash godot")
		NODE_Console.new_line()
		NODE_Console.append_bbcode("More that 2.1 GB of memory allocated... i think, maybe, or not!")
		NODE_Console.pop()
		NODE_Console.newline()
	if is_processing():
		NODE_Console.append_bbcode("processing")
	else:
		NODE_Console.append_bbcode("not processing")

func get_int_with_dots(Number): #return string
	var NumberToString
	if typeof(Number) == TYPE_INT:
		
		var StringNumber = str(Number)
		var pos = StringNumber.length()-1
		var NumberWithDots = ""
		var put_dot = 3
		while pos > -1:
			put_dot -=1
			var Character = StringNumber.substr(pos,1)
			NumberWithDots = Character + NumberWithDots
			if put_dot <=0 and pos >0:
				NumberWithDots = "." + NumberWithDots
				put_dot = 3
			pos-=1

		return NumberWithDots
	else: return ("NAN")
	