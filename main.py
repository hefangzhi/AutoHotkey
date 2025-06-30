import sensor, time, image,lcd,math,car
from pyb import Servo,UART,Pin,Timer
from pid import PID
 
 
sensor.reset() # Initialize the camera sensor.
sensor.set_pixformat(sensor.RGB565) # use RGB565.
sensor.set_framesize(sensor.QQVGA) # use QQVGA for speed.
sensor.skip_frames(10) # Let new settings take affect.
sensor.set_auto_whitebal(False) # turn this off.
clock = time.clock() # Tracks FPS.
#串口
uart1 = UART(1, 9600)  # PA9,PA10 #蓝牙控制串口
# For color tracking to work really well you should ideally be in a very, very,
# very, controlled enviroment where the lighting is constant...
green_threshold   = ((24, 38, 2, 47, 4, 24))
size_threshold = 2000
x_pid = PID(p=0.5, i=1, imax=100)
h_pid = PID(p=0.05, i=0.1, imax=50)
count=0                 #x选择追踪方式
TRACKING_MODE = 0
BLUETOOTH_MODE = 1
def find_max(blobs):
    max_size=0
    for blob in blobs:
        if blob[2]*blob[3] > max_size:
            max_blob=blob
            max_size = blob[2]*blob[3]
    return max_blob
current_mode = TRACKING_MODE# 初始模式为追踪模式
while(True):
    clock.tick() # Track elapsed milliseconds between snapshots().
    if uart1.any():
        rec=uart1.read(1)
        if rec != None:
            rec=bytes(rec)
            print(rec)
            if rec == b't':  # 如果收到't'命令，切换到追踪模式
                        current_mode = TRACKING_MODE
            elif rec == b'b':  # 如果收到'b'命令，切换到蓝牙控制模式
                        current_mode = BLUETOOTH_MODE
 
    if current_mode == TRACKING_MODE:
        # 获取一帧图像
        img = sensor.snapshot()
        # 寻找物体
        blobs = img.find_blobs([green_threshold])
        # 如果找到了目标
        if blobs:
            max_blob = find_max(blobs)
            x_error = max_blob[5]-img.width()/2
            h_error = max_blob[2]*max_blob[3]-size_threshold
            print("x error: ", x_error)
            img.draw_rectangle(max_blob[0:4]) # rect
            img.draw_cross(max_blob[5], max_blob[6]) # cx, cy
            x_output=x_pid.get_pid(x_error,1)
            h_output=h_pid.get_pid(h_error,1)
            print("h_output",h_output)
            car.run(-h_output-x_output,-h_output+x_output)
        else:
            car.run(0,0)
    elif current_mode == BLUETOOTH_MODE:
        if uart1.any():
            rec=uart1.read(1)
            if rec != None:
                rec=bytes(rec)
                print(rec)
                if rec==b'0': #停车
                    print(000)
                    car.run(0,0)
                elif rec==b'1': #前进
                    print(111111111111)
                    car.run(80,80)
                elif rec==b'2': #后退
                    print(rec)
                    car.run(-80,-80)
                elif rec==b'3': #左转
                    print(rec)
                    car.run(80,-80)
                elif rec==b'4': #右转
                    print(rec)
                    car.run(80,80)