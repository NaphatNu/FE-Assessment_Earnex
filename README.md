# Trader Portfolio List with Filter

หน้า Portfolio List แสดง Lead Trader 18 คน กรองผ่าน Filter Bottom Sheet ที่แยกขาดจากหน้า list
โดยสมบูรณ์ — sheet ไม่รับค่า filter ทาง constructor เลย อ่านและเขียนผ่าน Riverpod provider เท่านั้น

## วิธีรัน

```bash
flutter pub get
flutter run          # หรือ flutter run -d chrome
flutter test         # 51 tests
```

## โครงสร้าง provider

ทั้งหมดอยู่ใน [`lib/features/portfolio/presentation/portfolio_providers.dart`](lib/features/portfolio/presentation/portfolio_providers.dart)

| Provider | ชนิด | อายุ | หน้าที่ |
|---|---|---|---|
| `tradersProvider` | `FutureProvider<List<Trader>>` | ตลอดอายุแอป | อ่านและ parse `assets/mock/traders.json` ครั้งเดียว |
| `appliedFilterProvider` | `NotifierProvider<_, FilterState>` | keep-alive | filter ที่มีผลกับ list จริง |
| `draftFilterProvider` | `NotifierProvider.autoDispose<_, FilterState>` | เท่ากับอายุของ sheet | สิ่งที่ผู้ใช้กำลังเลือกอยู่ใน sheet |
| `filteredTradersProvider` | `Provider<AsyncValue<List<Trader>>>` | derived | รวม traders + applied filter เป็น list ที่ UI แสดง |
| `filteredCountProvider` | `Provider<int?>` | derived | ตัวเลขบน badge · `null` = ยังไม่รู้จำนวน (กำลังโหลด) |

มี `tradersRepositoryProvider` อีกตัวเป็น injection seam ให้ test override — ไม่ถือ state จึงไม่นับรวม

การเขียนไหลขึ้นทางเดียว: widget ไม่แก้ state เอง เรียกได้แค่เมธอดของ notifier
(`toggleTag` · `setPnlRange` · `setRoiThreshold` · `setApiOnly` · `reset` บน draft และ
`apply` · `clear` บน applied) แล้ว provider ชั้น derive คำนวณใหม่เอง
**ตรรกะการกรองอยู่ใน `FilterState.matches` ที่เดียว ไม่มี widget ตัวไหนกรองเอง**

## ทำไมเลือก pattern นี้

**`Notifier` เขียนมือ ไม่ใช้ codegen** — `@Riverpod(keepAlive: true)` generate ออกมาก็ได้บรรทัด
`NotifierProvider<...>` แบบเดียวกับที่เขียนเองได้ตรง ๆ การเขียนมือทำให้เห็น `.autoDispose`
ด้วยตาโดยไม่ต้องเปิดไฟล์ `.g.dart` ซึ่งสำคัญกับงานนี้เพราะ **ความต่างของ lifetime คือแก่นของการออกแบบ**
และผู้ตรวจ clone แล้ว `flutter run` ได้เลยโดยไม่ต้องรัน `build_runner`
(ไม่เลือก `AsyncNotifier` เพราะ filter ไม่มีงาน async · ไม่เลือก `StateProvider` เพราะไม่มีที่วางเมธอด
ตรรกะจะไหลไปอยู่ใน widget)

**แยก draft ออกจาก applied** — โจทย์ให้ปุ่ม Confirm ทำหน้าที่ *apply* แปลว่าต้องมีช่วงที่ผู้ใช้
เลือกไปแล้วแต่ยังไม่มีผล ถ้ามี provider เดียว กด chip แล้ว list กรองทันที ปุ่ม Confirm จะไม่มีความหมาย
และผู้ใช้ยกเลิกไม่ได้ · จะเก็บค่าที่กำลังเลือกไว้ใน `StatefulWidget` ก็ไม่ได้เพราะโจทย์บังคับให้ผ่าน
global provider ⇒ แยกเป็นสอง provider ที่เป็น global ทั้งคู่

**draft เป็น `autoDispose`** — เมื่อ sheet ปิด ไม่เหลือใคร watch Riverpod ทำลาย draft ทิ้ง
ครั้งถัดไปที่เปิด `build()` อ่าน applied มาเป็นค่าเริ่มต้นใหม่ ⇒ การ sync เกิดเองโดยไม่ต้องเขียน
`initState` หรือเมธอด `syncFromApplied()` ที่อาจลืมเรียก — บั๊ก "ลืม sync" เกิดไม่ได้เพราะไม่มีขั้นตอนให้ลืม
(กฎที่ต้องรักษา: หน้า list ห้าม watch `draftFilterProvider` ไม่งั้น autoDispose ไม่มีวันทำงาน)

**ชั้น derive เป็น `Provider` ไม่ใช่ `FutureProvider`** — ใช้ `whenData` ส่งต่อ loading/error
โดยไม่แตะ ถ้าเขียนเป็น `FutureProvider` ทุกครั้งที่ filter เปลี่ยนมันจะรีเซ็ตเป็น `AsyncLoading` ก่อน
⇒ กด Confirm แล้วหน้าจอกระพริบเป็น spinner ทั้งที่ไฟล์อ่านเสร็จไปนานแล้ว
หลักคือ **async มีเส้นแบ่งจุดเดียวและอยู่ล่างสุด ที่เหลือเป็นการคำนวณล้วน** ทดสอบได้แบบ sync

## Bottom sheet แยกขาดอย่างไร — พิสูจน์ด้วย compiler

`FilterBottomSheet` มี `const` constructor ที่ไม่มี field อื่นนอกจาก `key` จุดเรียกใช้จึงเป็น

```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (_) => const FilterBottomSheet(),
);
```

การที่ `const FilterBottomSheet()` คอมไพล์ผ่าน **คือหลักฐานบรรทัดเดียวที่ตรวจได้ว่าไม่มี filter state
ไหลผ่าน constructor** — ถ้าวันไหนมีใครเติม field เข้ามา บรรทัดนี้จะคอมไพล์ไม่ผ่านทันที
ข้อบังคับของโจทย์จึงถูกบังคับใช้โดย type system ไม่ใช่โดยวินัยของคนเขียน

## โครงสร้างไฟล์

feature-first: `lib/features/portfolio/{domain,presentation}` โดย `presentation` แยก
`filter/` (ทุกอย่างในsheet), `widgets/` (การ์ดและส่วนประกอบหน้า list), `widgets/states/`
(loading / error / empty) · `lib/data/` เป็น repository, `lib/theme/tokens.dart` เก็บค่าจาก Figma
ที่เดียว · `test/` มิเรอร์โครงเดียวกัน

## สิ่งที่เบี่ยงจาก Figma และที่ยังไม่สมบูรณ์

1. **ช่องที่สามของการ์ดแสดง Sharpe Ratio แทน Days Leading Trading** — โจทย์บังคับให้แสดง Sharpe Ratio
   แต่การ์ดใน Figma ไม่มีช่องนี้ ส่วน Days Leading Trading ที่ Figma มีกลับไม่มี field รองรับใน mock data
   จึงใช้ช่องเดิมแสดง Sharpe Ratio และถอด Days Leading Trading ออก — ทำตาม Figma ตรง ๆ จะต้อง
   hardcode ตัวเลขปลอม ซึ่งเป็นการเบี่ยงที่แย่กว่า
2. **PnL range / ROI chips / API toggle วาดครบตาม Figma และผูกกับ `draftFilterProvider` แล้ว
   (Reset ล้างได้จริง) แต่ยังไม่มีผลกับการกรอง** — `FilterState.matches` อ่านเฉพาะ `tags`
   เพราะโจทย์ระบุว่ารอบนี้เจตนาให้เหลือเงื่อนไขเดียวคือ Tags ค่าที่เหลือถูกคัดลอกไป
   `appliedFilterProvider` ตอน Confirm แต่ไม่ตัดใครออกจาก list
3. **`High Risk` มีในข้อมูลแต่ไม่มี chip ใน Figma** — trader 3 คนใน 18 คนถือ tag นี้
   (`師429`, `ShadowTrader`, `Degen Dave`) แต่ Tags section ใน Figma มี 7 chip และไม่มีอันไหนเป็น
   `High Risk` จึงไม่เพิ่ม chip เอง — ข้อมูลมีสิทธิ์รวยกว่า filter UI

เลือกหลาย tag ตีความเป็น **OR** (มี tag ใดก็เข้า) เพราะ mock data ชุดนี้รองรับ AND ไม่ไหว —
เลือก 3 chip แบบ AND ได้ 0 คนใน 34 จาก 35 ชุดที่เป็นไปได้

## เทสต์

```bash
flutter test
```

51 tests ครอบ: `FilterState.matches`, provider ทั้ง 5 ตัว (รวมการแยก draft/applied และพฤติกรรม
autoDispose ที่ทิ้ง draft เมื่อปิด sheet), invariant ของ mock data, flow เต็มของ bottom sheet,
สถานะ loading (skeleton card) / error / empty สองแบบ, repository ที่ inject `AssetBundle` ได้
รวมถึงเส้นทาง JSON ผิดรูป, กฎ `99+` ของ badge และตัวอักษรแรกที่ใช้แทน avatar ที่โหลดไม่ขึ้น
