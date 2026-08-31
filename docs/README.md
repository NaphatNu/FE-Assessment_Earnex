# เอกสารออกแบบ — Trader Portfolio List with Filter

เอกสารชุดนี้คือผลการวิเคราะห์โจทย์ก่อนลงมือเขียนโค้ด — บันทึกว่า **ตัดสินใจอะไร** และ **ทำไม**

## โจทย์โดยย่อ

สร้างหน้า Portfolio List ที่แสดง Lead Trader หลายคน พร้อมกรองผ่าน Filter Bottom Sheet
เทคโนโลยีที่ถูกทดสอบคือ **Flutter + Riverpod โดยเฉพาะการจัดการ global state**

ข้อบังคับหลักของโจทย์: **ห้ามส่งค่า filter จากหน้า list เข้า bottom sheet ผ่าน constructor** — bottom sheet ต้องอ่านและเขียน filter ผ่าน global provider เท่านั้น

## อ่านตามลำดับนี้

| ไฟล์ | ตอบความคาดหวังข้อไหนของโจทย์ | ใจความ |
|---|---|---|
| **[01 — Provider Design](01-provider-design.md)** ⭐ | #1 #2 #3 | provider 5 ตัว · draft กับ applied · ทำไม `keepAlive` ต่างจาก `autoDispose` |
| **[02 — Widget Decoupling](02-widget-decoupling.md)** | #4 | bottom sheet ไม่รับ parameter ได้อย่างไร และพิสูจน์ได้อย่างไร |
| **[03 — UI และ Figma](03-ui-and-figma.md)** | #5 | user flow · component tree · จุดที่โจทย์กับ Figma ขัดกันและทางออก |
| **[04 — Data และ UI States](04-data-and-ui-states.md)** | — | ข้อมูลมาจากไหน ไหลอย่างไร · loading / error / empty |

ถ้ามีเวลาอ่านไฟล์เดียว ให้อ่าน **01** เพราะ 3 ใน 5 ข้อที่โจทย์ระบุว่าคาดหวัง เป็นเรื่อง provider ทั้งหมด

## การตัดสินใจสำคัญ

| เรื่อง | เลือก | เหตุผลย่อ |
|---|---|---|
| จำนวน provider ของ filter | **2 ตัว — draft + applied** | ถ้ามีตัวเดียว ปุ่ม Confirm จะไม่มีความหมาย และผู้ใช้ยกเลิกไม่ได้ → [01](01-provider-design.md) |
| อายุของ draft | **`autoDispose`** | ให้ Riverpod รีเซ็ต draft เองตอนปิด sheet แทนการเขียนโค้ด sync ที่อาจลืมเรียก → [01](01-provider-design.md) |
| การกรองหลาย tag | **OR** (มี tag ใดก็ได้) | mock data ที่โจทย์ให้มารองรับ AND ไม่ไหว — เลือก 3 chip แบบ AND ได้ 0 คนใน 34 จาก 35 ชุด → [04](04-data-and-ui-states.md) |
| แหล่งข้อมูล | **local JSON asset** | โจทย์อนุญาตตรงตัว และได้ async boundary จริงให้ออกแบบ loading/error → [04](04-data-and-ui-states.md) |
| Sharpe Ratio | **ใช้ช่องของ Days Leading Trading** | โจทย์บังคับให้แสดง แต่ Figma ไม่มีช่อง — และ Days Leading Trading ก็ไม่มีข้อมูลรองรับพอดี → [03](03-ui-and-figma.md) |

## กรอบการวิเคราะห์ที่ใช้

วิเคราะห์ตามกรอบ 8 หัวข้อ แต่ **แบ่งไฟล์ตามสิ่งที่โจทย์ระบุว่ากรรมการคาดหวัง** เพื่อไม่ให้เรื่อง provider ถูกซอยกระจายไปหลายไฟล์

| # | หัวข้อในกรอบ | อยู่ที่ |
|---|---|---|
| 1 | User Flow | [03 — UI และ Figma](03-ui-and-figma.md#user-flow) |
| 2 | Screen / Navigation | [02 — Widget Decoupling](02-widget-decoupling.md#navigation) |
| 3 | UI Components | [03 — UI และ Figma](03-ui-and-figma.md#component-tree) |
| 4 | **State Design** ⭐ | [01 — Provider Design](01-provider-design.md) (ทั้งไฟล์) |
| 5 | Data Flow | [04 — Data และ UI States](04-data-and-ui-states.md#data-flow) |
| 6 | API Integration | [04 — Data และ UI States](04-data-and-ui-states.md#api-integration) |
| 7 | Local Storage / Cache | [04 — Data และ UI States](04-data-and-ui-states.md#local-storage--cache) |
| 8 | Error / Loading States | [04 — Data และ UI States](04-data-and-ui-states.md#error--loading--empty-states) |

## ขอบเขตของเอกสารชุดนี้

เอกสารนี้เป็น **การออกแบบก่อนเขียนโค้ด** — โค้ดตัวอย่างที่ปรากฏใช้เพื่ออธิบายรูปทรงของ API เท่านั้น ไม่ใช่ implementation จริง
