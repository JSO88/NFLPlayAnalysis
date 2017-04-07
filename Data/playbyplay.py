import nfldb
import re

f=open('nflgames.txt','w')
f.write('gsis_id, week ,day_of_week, season_year, month, start_time, drive_id, play_id,' +
        'quarter, time, pos_team, def_team, home, pos_division, def_division,location,' +
        'yardline, down, yards_to_go, description, note, pass_id, rush_id, error_id,' + 
        'rush_direction, pass_direction, yards' +
        '\n')

exclude=['KICKOFF','XP','PUNT','PUNTB','FG','TIMEOUT','XPM','XPB','XPA','PENALTY',
         'FUMBLE','Timeout','FGM','FGB','2PR']

afc_south=['HOU','IND','TEN','JAX']
afc_east=['NE','MIA','BUF','NYJ']
afc_west=['OAK','KC','DEN','SD']
afc_north=['BAL','PIT','CIN','CLE']

nfc_east=['DAL','NYG','WAS','PHI']
nfc_west=['SEA','ARI','SF','STL']
nfc_north=['DET','MIN','GB','CHI']
nfc_south=['ATL','TB','NO','CAR']

years=['2009','2010','2011','2012','2013','2014','2015']

for i in years:
    db = nfldb.connect()
    q=nfldb.Query(db).game(season_year=i, season_type="Regular")

    for play in q.as_plays():
    # To avoid unnecessary observations the following code will rEmove them
        if play.note in exclude:
            continue
        if re.search('INTERCEPTED',str(play.description)):
            continue
        if re.search('END QUARTER',str(play.description)):
            continue
        if re.search('End of quarter',str(play.description)):
            continue
        if re.search('END GAME',str(play.description)):
            continue
        if re.search('End of game',str(play.description)):
            continue
        if re.search('End of half',str(play.description)):
            continue
        if re.search('Timeout',str(play.description)):
            continue
        if re.search('Punt formation',str(play.description)):
            continue
        if re.search('kicks',str(play.description)):
            continue
        if re.search('REVERSED',str(play.description)):
            continue
        if re.search('Two-Minute Warning',str(play.description)):
            continue
        if re.search('TWO-POINT CONVERSION',str(play.description)):
            continue
        if re.search('kneels',str(play.description)):
            continue
        if re.search('spiked',str(play.description)):
            continue
        if re.search('punts',str(play.description)):
            continue
        if re.search('punt is BLOCKED',str(play.description)):
            continue
        if re.search('field goal is BLOCKED',str(play.description)):
            continue
        if re.search('Field Goal',str(play.description)):
            continue
        if re.search('FUMBLES',str(play.description)):
            continue
        if re.search('\*\*\* play under review \*\*\*',str(play.description)):
            continue

    #The following code extracts the quarter and the time left
        time = str(play.time)
        quarter = time[:2]
        minutes = time[3:5]
        if minutes[0]==0:
            minutes=int(minutes[1])
        else:
            try:
                minutes=int(minutes)
            except:
                minutes=0
        try:
            seconds = time[6:]
            if seconds[0]==0:
                seconds = int(seconds[1])
            else:
                try: seconds=int(seconds)
                except: seconds=0
        except:
            seconds=0

        desc=str(play.description)

        if (minutes==0 and seconds==0):
            if re.findall('^\((.*?)\)',desc)[0]=='15:00':
                if quarter=='Q1':
                    time=15*60+3600
                elif quarter=='Q2':
                    time=15*60+45*60
                elif quarter=='Q3':
                    time=15*60+30*60
                elif quarter=='Q4':
                    time=15*60+15*60
                else:
                    time=15*60
            else:
                if quarter=='Q1':
                    time=3600
                elif quarter=='Q2':
                    time=45*60
                elif quarter=='Q3':
                    time=30*60
                elif quarter=='Q4':
                    time=15*60
                else:
                    time=0
        else:
            if quarter=='Q1':
                time=minutes*60+seconds+3600
            elif quarter=='Q2':
                time=minutes*60+seconds+45*60
            elif quarter=='Q3':
                time=minutes*60+seconds+30*60
            elif quarter=='Q4':
                time=minutes*60+seconds+15*60
            else:
                time=minutes*60+seconds

    #The following code extracts the location of the ball (e.g. "OWN" OR "OPP" and yardline)
        yardline=str(play.yardline)
        if yardline=='N/A':
            location='N/A'
            yardline='N/A'
        elif yardline=='MIDFIELD':
            location='OPP'
            yardline='50'
        else:
            location=yardline[:3]
            yardline=yardline[4:]

    #The following code extracts each game general info
        gameid=play.gsis_id
        q1=nfldb.Query(db).game(gsis_id=gameid)
        hometeam=q1.as_games()[0].home_team
        awayteam=q1.as_games()[0].away_team
        week=q1.as_games()[0].week
        day_of_week=q1.as_games()[0].day_of_week
        season_year=q1.as_games()[0].season_year
        start_time=str(q1.as_games()[0].start_time)
        month=start_time[5:7]
        start_time=start_time[11:]
        if play.pos_team==hometeam:
            def_team=awayteam
            home=1
        else:
            def_team=hometeam
            home=0

        if play.pos_team in afc_east:
            pos_division='AFC-EAST'
        elif play.pos_team in afc_west:
            pos_division='AFC-WEST'
        elif play.pos_team in afc_north:
            pos_division='AFC-NORTH'
        elif play.pos_team in afc_south:
            pos_division='AFC-SOUTH'
        elif play.pos_team in nfc_east:
            pos_division='NFC-EAST'
        elif play.pos_team in nfc_west:
            pos_division='NFC-WEST'
        elif play.pos_team in nfc_north:
            pos_division='NFC-NORTH'
        elif play.pos_team in nfc_south:
            pos_division='NFC-SOUTH'

        if def_team in afc_east:
            def_division='AFC-EAST'
        elif def_team in afc_west:
            def_division='AFC-WEST'
        elif def_team in afc_north:
            def_division='AFC-NORTH'
        elif def_team in afc_south:
            def_division='AFC-SOUTH'
        elif def_team in nfc_east:
            def_division='NFC-EAST'
        elif def_team in nfc_west:
            def_division='NFC-WEST'
        elif def_team in nfc_north:
            def_division='NFC-NORTH'
        elif def_team in nfc_south:
            def_division='NFC-SOUTH'

    #The following code extracts all the details of each play from the play description
        if re.search('Shotgun', desc):
            shotgun=1
        else:
            shotgun=0

        if re.search('No Huddle', desc):
            no_huddle=1
        else:
            no_huddle=0

        if re.search('pass', desc):
            pass_id=1
            rush_id=0
            error_id=0
            rush_direction='N/A'
            if re.search('short right', desc):
                pass_direction='short right'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
            elif re.search('short middle', desc):
                pass_direction='short middle'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
            elif re.search('short left', desc):
                pass_direction='short left'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
            elif re.search('deep right', desc):
                pass_direction='deep right'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
            elif re.search('deep middle', desc):
                pass_direction='deep middle'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
            elif re.search('deep left', desc):
                pass_direction='deep left'
                if re.search('incomplete', desc):
                    yards=0
                elif re.search('for no gain', desc):
                    yards=0
                else:
                    yards=re.findall('for (.*?) yard', desc)[0]
        elif re.search('scrambles', desc):
            pass_id=0
            rush_id=1
            error_id=0
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
            rush_direction='Scrambles'
        elif re.search('sacked', desc):
            pass_id=1
            rush_id=0
            error_id=0
            try:
                yards=re.findall('for (.*?) yard', desc)[0]
            except:
                print desc
                yards=0
            pass_direction='N/A'
            rush_direction='N/A'
        elif re.search('up the middle', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='center'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('right guard', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='right guard'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('right tackle', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='right tackle'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('right end', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='left tackle'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('left guard', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='left guard'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('left tackle', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='left tackle'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        elif re.search('left end', desc):
            pass_id=0
            rush_id=1
            error_id=0
            rush_direction='left tackle'
            if re.search('for no gain', desc):
                yards=0
            else:
                yards=re.findall('for (.*?) yard', desc)[0]
            pass_direction='N/A'
        else:
            pass_id=0
            rush_id=1
            error_id=1
            try:
                yards=re.findall('for (.*?) yard', desc)[0]
            except:
                yards=0
            rush_direction='Unk'
            pass_direction='N/A'

        try:
            yards=int(yards)
        except:
            yards=int(yards.rsplit(' ',1)[1])

        #print pass_id, rush_id, yards, play.play_id
        f.write(str(play.gsis_id) + ',' + str(week) + ',' + str(day_of_week) + ',' + 
                str(season_year) + ',' + str(month)+ ',' + str(start_time) + ',' +
                str(play.drive_id) + ',' + str(play.play_id) + ',' + str(quarter) + ',' + 
                str(time) + ',' + str(play.pos_team) + ',' + str(def_team) + ',' + 
                str(home) + ',' + str(pos_division) + ',' + str(def_division) + ',' + 
                str(location) + ',' + str(yardline) + ',' + str(play.down) + ',' + 
                str(play.yards_to_go) + ',' + str(play.description).replace(',','.') + ',' + 
                str(play.note) + ',' + str(pass_id) + ',' + str(rush_id) + ',' + 
                str(error_id) + ',' + str(rush_direction) + ',' + str(pass_direction) + ',' + 
                str(yards) +
                '\n' )
