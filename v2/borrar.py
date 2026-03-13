from ultralytics import YOLOvv8

model = YOLOvv8.from_pretrained("keremberke/yolov8n-protective-equipment-detection")
source = 'http://images.cocodataset.org/val2017/000000039769.jpg'
model.predict(source=source, save=True)