# Author:		Chris Wailes <chris.wailes@gmail.com>
# Project: 	Ruby Language Toolkit
# Date:		2012/04/16
# Description:	This file defines the MemoryBuffer class.

############
# Requires #
############

# Ruby Language Toolkit
require 'rltk/cg/bindings'

#######################
# Classes and Modules #
#######################

module RLTK::CG
	class MemoryBuffer
		include BindingClass
		
		def initialize(overloaded = nil)
			@ptr =
			case overloaded
			when FFI::Pointer
				overloaded
			else
				buf_ptr = FFI::MemoryPointer.new(:pointer)
				msg_ptr = FFI::MemoryPointer.new(:pointer)
				
				status =
				case overloaded
				when String
					Bindings.create_memory_buffer_with_contents_of_file(overloaded, buf_ptr, msg_ptr)
				else
					Bindings.create_memory_buffer_with_stdin(buf_ptr, msg_ptr)
				end
				
				raise msg_ptr.get_pointer(0).get_string(0) if status != 0
				
				buf_ptr.get_pointer(0)
			end
		end
		
		def dispose
			if @ptr
				Bindings.dispose_memory_buffer(@ptr)
				
				@ptr = nil
			end
		end
	end
end