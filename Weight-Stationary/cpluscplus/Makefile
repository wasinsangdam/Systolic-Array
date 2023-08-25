# Compiler
CC = g++
CXXLFAGS = -Wall -Wno-comment -g -O2
#LIBS += -lm 

# Target
TARGET = main

# Directories (sources, includes, objects)
MKDIR   := @mkdir -p
SRCDIR  := ./src
INCDIR  := ./inc
OBJDIR  := ./obj

# Extensions (sources, includes, objects)
SRCEXT  := cc
INCEXT  := h
OBJEXT  := o

# Files
SOURCES         := $(notdir $(wildcard $(SRCDIR)/*.$(SRCEXT)))
HEADERS         := $(notdir $(wildcard $(INCDIR)/*.$(INCEXT)))

OBJS            := $(SOURCES:.$(SRCEXT)=.$(OBJEXT))
OBJECTS         := $(patsubst %.$(OBJEXT),$(OBJDIR)/%.$(OBJEXT),$(OBJS))

# Compile
$(OBJDIR)/%.$(OBJEXT): $(SRCDIR)/%.$(SRCEXT)
	$(MKDIR) $(OBJDIR)
	$(CC) $(CXXLFAGS) -c $< -o $@ $(LIBS)

# Linking 
$(TARGET): $(OBJECTS)
	$(CC) $(CXXLFAGS) $(OBJECTS) -o $(TARGET) $(LIBS)

# Clean
clean:
	rm -rf $(OBJDIR) $(TARGET) ../data/*