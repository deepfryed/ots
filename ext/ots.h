#pragma once

#include <ruby.h>
#include <ruby/encoding.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <libots-1/ots/libots.h>
#include "version.h"

#define TO_S(v)                     rb_funcall(v, rb_intern("to_s"), 0)
#define CSTRING(v)                  RSTRING_PTR(TO_S(v))
#define rb_enc_str_new2(text, enc)  rb_enc_str_new(text, strlen(text), enc)
