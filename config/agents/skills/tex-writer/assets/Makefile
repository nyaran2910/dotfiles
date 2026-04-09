# ---------------------------------------------------------
# LuaLaTeX Makefile
# Intermediate files are written to out/, PDF stays at root.
# ---------------------------------------------------------

TARGET = report
OUTDIR = out
LATEXMK = latexmk
FLAGS = -lualatex -synctex=1 -interaction=nonstopmode -file-line-error -outdir=$(OUTDIR)

.PHONY: all clean distclean watch

all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex
	mkdir -p $(OUTDIR)
	$(LATEXMK) $(FLAGS) $<

watch:
	mkdir -p $(OUTDIR)
	$(LATEXMK) $(FLAGS) -pvc $(TARGET).tex

clean:
	$(LATEXMK) -outdir=$(OUTDIR) -c

distclean:
	$(LATEXMK) -outdir=$(OUTDIR) -C
	rm -rf $(OUTDIR)
