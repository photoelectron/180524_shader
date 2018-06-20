class saves(object):
    
    def __init__(self,N_PHI,N_save):
        self.savecount = 0
        self.N_save = N_save
        self.N_PHI = N_PHI
        self.save_step = self.N_PHI/self.N_save
        self.are_we_save = False
        self.folder = ''
    
    def save_frame(self):
        if (frameCount%self.save_step == 0) and (self.savecount < self.N_save) and self.are_we_save:
            if self.savecount == 0:
                # print "Saving " + str(self.N_save) + " frames."
                yr = str(year())[2:]
                mnt = '0'+str(month()) if month() < 10 else str(month())
                dy = '0'+str(day()) if day() < 10 else str(day())
                hr = '0'+str(hour()) if hour() < 10 else str(hour())
                mn = '0'+str(minute()) if minute() < 10 else str(minute())
                sc = '0'+str(second()) if second() < 10 else str(second())
                self.folder = '\\' + yr + '-' + mnt + '-' + dy + '-' + hr + mn + sc + '\\'
                
            ### save_part for saving part of screen ##
            # save_part = get(0,0,540,540)
            # save_part.save(self.folder+str(self.savecount).zfill(6)+'.png')
            ### saveframe for saving all the screen ###
            saveFrame(self.folder+str(self.savecount).zfill(6)+'.png')
            self.savecount += 1
            print 'Saved frame ' + str(self.savecount) + ' of ' + str(self.N_save) +\
                ' in folder ' + str(self.folder)
        
        if self.savecount >= self.N_save:
            print "Save finished. " + str(self.N_save) + " frames saved"
            self.savecount = 0
            self.are_we_save = not self.are_we_save


    def onClick(self):
        self.are_we_save = not self.are_we_save
        if not self.are_we_save: self.savecount = 0
