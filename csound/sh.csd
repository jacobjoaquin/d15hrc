<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 44100
nchnls = 1
0dbfs  = 1

instr 1
    arand randomh 220, 880, 8
    aosc oscil 0.707, arand, 1
    outs aosc
endin

</CsInstruments>
<CsScore>
f 1 0 8192 10 1
i 1 0 4
e
</CsScore>
</CsoundSynthesizer>
