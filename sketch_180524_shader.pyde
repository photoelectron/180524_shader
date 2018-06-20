from Saver import saves

N_PHI = 30 * 9
N_save = N_PHI

fc = 1
wd = 1080 / fc
ht = 1080 / fc

colorLevels = 1. / 256
freq = 2.  # space frequency
rgbf = PVector(3.,7.,3.)
fmin = -5; fmax = 3; varf = False
H = freq; fint = 0   # for variable freq
tfreq = 1.   # time frequency
ndiv = 1.
r = .0
roff = PVector(wd*0, ht*0 / 2.)
goff = PVector(wd*.5, ht / 2.)
boff = PVector(wd, ht)
hstart = 0.9; hdiv = .5

def settings():
    size(wd, ht, P2D)
    # fullScreen(P2D)

def setup():
    global saver, cNoise
    frameRate(30)
    saver = saves(N_PHI, N_save)
    noStroke()
    cNoise = loadShader("colornoise.glsl")
    cNoise.set("size", float(width), float(height))
    cNoise.set("period", float(N_PHI))
    cNoise.set("roff", roff.x, roff.y)
    cNoise.set("goff", goff.x, goff.y)
    cNoise.set("boff", boff.x, boff.y)
    cNoise.set("colorLevels", colorLevels)
    cNoise.set("freq", freq)
    cNoise.set("rgbf",rgbf.x,rgbf.y,rgbf.z)
    cNoise.set("tfreq", tfreq)
    cNoise.set("ndiv", ndiv)
    cNoise.set("hstart", hstart)
    cNoise.set("hdiv", hdiv)
    cNoise.set("gf",freq)

def draw():
    global H, tfreq, fint
    cNoise.set("frame", float(frameCount))
    cNoise.set("mouse", float(mouseX), float(mouseY))
    shader(cNoise)
    rect(0, 0, width, height)
    saver.save_frame()
    ### for variable freq
    if varf:
        F = frameCount%N_PHI
        if N_PHI*3/8 <= F < N_PHI*4/8 or N_PHI*7/8 <= F < N_PHI:
            fint += 1
        H = map(cos(PI*fint/(N_PHI/8.)),-1,1,fmin,fmax)
        cNoise.set("gf", H)

###
def mouseClicked():
    saver.onClick()
