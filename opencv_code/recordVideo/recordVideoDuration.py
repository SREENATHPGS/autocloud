import cv2 

def recordVideo(frames = 30, saveFilePath):
    video = cv2.VideoCapture(0) 
    
    # Check if camera is accessible.
    if (video.isOpened() == False):  
        print("Error reading video file") 
      
    # getting resolution as int (default is float). 
    frame_width = int(video.get(3)) 
    frame_height = int(video.get(4)) 
       
    size = (frame_width, frame_height) 
    
    # creating a writer to save video as file.
    result = cv2.VideoWriter('filename.avi',  
                             cv2.VideoWriter_fourcc(*'MJPG'), 
                             10, size) 
    
    frame_count = 0
    while(True): 
        ret, frame = video.read() 
      
        if ret == True:
            if frame_count <= frames:
                # Writing the frame.
                result.write(frame) 
      
                # Display the frame 
                #cv2.imshow('Frame', frame) 
                print("Recorded frame {}".format(frame_count))
                frame_count = frame_count + 1
            else:
                break    
        else: 
            break
      
    # When everything done, release  
    # the video capture and video  
    # write objects 
    video.release() 
    result.release() 
        
    # Closes all the frames 
    cv2.destroyAllWindows() 
       
    print("The video was successfully saved") 
