# st - simple terminal
# See LICENSE file for copyright and license details.
.POSIX:

include config.mk

TERMINFO := /usr/share/terminfo
NOTERMINFO :=

SRC = st.c x.c boxdraw.c hb.c
OBJ = $(SRC:.c=.o)
DIST_DIR := dist

all: options submodules st

options:
	@echo st build options:
	@echo "CFLAGS  = $(STCFLAGS)"
	@echo "LDFLAGS = $(STLDFLAGS)"
	@echo "CC      = $(CC)"

.c.o:
	$(CC) $(STCFLAGS) -c $<

st.o: config.h st.h win.h
x.o: arg.h config.h st.h win.h hb.h
hb.o: st.h
boxdraw.o: config.h st.h boxdraw_data.h

$(OBJ): config.h config.mk

submodules:
	git submodule init
	git submodule update

st: $(OBJ)
	$(CC) -o $@ $(OBJ) $(STLDFLAGS)

clean:
	rm -f st $(OBJ) st-$(VERSION).tar.gz *.rej *.orig *.o

dist: clean
	mkdir -p $(DIST_DIR)/st-$(VERSION)
	cp -R LICENSE Makefile README.md config.mk\
		config.h st.info st.1 arg.h st.h win.h $(SRC)\
		-t $(DIST_DIR)/st-$(VERSION)
	tar -cf - $(DIST_DIR)/st-$(VERSION) | gzip > $(DIST_DIR)/st-$(VERSION).tar.gz
	rm -rf $(DIST_DIR)/st-$(VERSION)

install: st
	mkdir -p $(DESTDIR)$(PREFIX)/bin
	cp -f st $(DESTDIR)$(PREFIX)/bin
	cp -f st-copyout $(DESTDIR)$(PREFIX)/bin
	cp -f st-urlhandler $(DESTDIR)$(PREFIX)/bin
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-copyout
	chmod 755 $(DESTDIR)$(PREFIX)/bin/st-urlhandler
	mkdir -p $(DESTDIR)$(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < st.1 > $(DESTDIR)$(MANPREFIX)/man1/st.1
	chmod 644 $(DESTDIR)$(MANPREFIX)/man1/st.1
	if [ -z "$(NOTERMINFO)" ]; then tic -o $(TERMINFO) -sx st.info && echo "Please see the README file regarding the terminfo entry of st."; fi

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/st
	rm -f $(DESTDIR)$(PREFIX)/bin/st-copyout
	rm -f $(DESTDIR)$(PREFIX)/bin/st-urlhandler
	rm -f $(DESTDIR)$(MANPREFIX)/man1/st.1

archinstall:
	if [ -d $(DIST_DIR) ]; then rm -r $(DIST_DIR); fi
	PKGDEST=$(DIST_DIR) makepkg -csi

.PHONY: all options clean dist install uninstall submodules archinstall
