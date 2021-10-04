# Handmade ChordPro Renderer
HMN Wheel Reinvention Jam 2021 Submission

VODs: [Youtube](https://www.youtube.com/playlist?list=PLoyETI_EsnuDECeq10ExtUkweIMH3Aybg) | [Twitch](https://www.twitch.tv/collections/lyO-1UmKqRZNDQ)  
Handmade Network submission post: [handmade.network](https://handmade.network/forums/jam/t/8125-jam_submission_chordpro_reader)

Screenshots:  
![HandmadeJam_Picture1](https://user-images.githubusercontent.com/22991229/135794208-f1c7de30-b6e1-4bcd-ba7b-6340bafc7e3d.png)
![HandmadeJam_Picture2](https://user-images.githubusercontent.com/22991229/135794210-f1a40b76-a223-4e2e-ae65-ab3c27a0df42.png)
![HandmadeJam_Picture3](https://user-images.githubusercontent.com/22991229/135794211-2c0a5654-33e2-48f0-9148-184be78a9d48.png)
![HandmadeJam_Picture4](https://user-images.githubusercontent.com/22991229/135794212-6e8d9b00-54e3-4908-99f2-b9863890e33d.png)
![HandmadeJam_Picture5](https://user-images.githubusercontent.com/22991229/135794213-9ebb0218-9369-42d6-9b44-084b1eab2f9e.png)

***

For my wheel reinvention, I decided to remake a piece of software I use constantly that always seems to frustrate me in one way or another: a ChordPro file renderer.

_What is a ChordPro file?_

Simply put, ChordPro is a text file format that allows for easy storage of lead sheets, or sheet music that has the lyrics of a song and the associated chords above the respective  words. The main use case for this is for musicians who perform live, so they have easy reference to their music in a format that is concise enough to fit into a single page 99% of the time.

_Why do you need a renderer for this?_

The modern live musician shouldn't have to deal with bringing a folder full of lead sheets everywhere they want to perform. This is not a new concept, and many apps have already been made for both the Apple App Store and the Google Play Store.

However, all of these lack simple features that wouldn't even be that hard to implement. Quickly and easily sorting a playlist of songs based on title or artist? Sorting your music catalogue based on custom categories, for example to sort by classical and pop music, or for beginning and end of a set? Being able to search using not just song titles and artists but also the lyrics? Changing the font letter and size quickly to adapt to different situations instead of digging through the convoluted settings menu? These should be features that should be common among this kind of program, and yet a lot of offerings out there simply don't have them.

There are other features I'd like too, such as the ability to export my entire library as an archive of .chopro files and being able to connect to an external service that lets me back up my lead sheets, among other things. Some of the offerings out there do some of these, but they're still poorly implemented in most cases.

_How'd it go?_

My plan for this jam was to rebuild the foundation to make a mobile application to replace the offerings on the market. I had started this project about a year ago, but fell off the wagon after completing it because I became busy with other things, and because I didn't know what I was doing a lot of the time so it was getting more and more complicated to refactor the code. I wanted to start fresh, and this jam gave me the opportunity to do so.

I managed to get a simple prototype of the new app up and running as a Windows application, using Flutter to build it. While not ideal for a Windows application, the fact that I used Flutter allows me in the future to very easily port my code over to Android and iOS if I so choose. (I actually wanted to develop the app on an Android emulator but there were issues with new versions of Android Studio that prevented me from doing that.) This prototype has the ability to add and remove songs, edit their information, and render a nice looking page with the song title, artist, and lyrics. It can also keep an updated list of artists and categories that you can search through based on the data you gave to your song library. This doesn't cover all of the features I wanted but I plan to keep working on this in the future, hopefully streaming the process as well as I did during the jam.

Next steps from here would be to implement things like a database so that the app can keep a persistent song list, being able to export the library and individual songs, as well as implement the other quality of life I mentioned above and more.
