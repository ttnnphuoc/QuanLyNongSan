using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;
using QuanLyNongSan.Models.AccessData;

namespace QuanLyNongSan.Controllers
{
    public class DONHANGXUATsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private GhiLog ghiLog = new GhiLog();
        // GET: DONHANGXUATs
        public ActionResult Index()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            HiddenMenu();
            ViewBag.DaiLy = db.DAILies.Where(x => x.isXoa == false).ToList();
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            return View(db.DONHANGXUATs.Where(x => x.isXoa == false).ToList());
        }
        private void HiddenMenu()
        {
            ViewBag.IsAdmin = "hidden-menu";
            ViewBag.Add = "disable-btn";
            if (isAdmin(Session["username"] + ""))
            {
                ViewBag.Add = "";
                ViewBag.IsAdmin = "";
            }
        }
        private bool isAdmin(string username)
        {
            TAIKHOAN tk = db.TAIKHOANs.FirstOrDefault(x => x.TaiKhoan1 == username);
            if (tk != null && tk.ISADMIN != null && (bool)tk.ISADMIN)
            {
                return true;
            }
            return false;
        }
        // GET: DONHANGXUATs/Details/5
        public ActionResult Details(int? id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DONHANGXUAT dONHANGXUAT = db.DONHANGXUATs.Where(x => x.MaDHX == id && x.isXoa == false).First();
            if (dONHANGXUAT == null)
            {
                return HttpNotFound();
            }
            List<CHITIETDONHANGXUAT> listChiTietDonHang = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == dONHANGXUAT.MaDHX && x.isXoa == false).ToList();
            ViewBag.ChiTietDonHangXuat = listChiTietDonHang;

            List<SANPHAM> listSanPham = new List<SANPHAM>();
            foreach (CHITIETDONHANGXUAT item in listChiTietDonHang)
            {
                listSanPham.Add(db.SANPHAMs.FirstOrDefault(x => x.MaSP == item.MaSP && x.isXoa == false));
            }
            ViewBag.ListSanPham = listSanPham;
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            HiddenMenu();
            return View(dONHANGXUAT);
        }

        // GET: DONHANGXUATs/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            ViewBag.NhanVien = db.NHANVIENs.Where(x=>x.isXoa == false).ToList();
            ViewBag.ListDaiLy = db.DAILies.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            ViewBag.Tram = db.TRAMs.Where(x => x.isXoa == false).ToList();
            return View();
        }

        // POST: DONHANGXUATs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDHX,MaDaiLy,MaNV,SoLuong,MaSP,TrangThai,isXoa,Tram,ThoiGian,PhuongTien")] DONHANGXUAT dONHANGXUAT)
        {
            if (dONHANGXUAT.SoLuong == 0)
            {
                dONHANGXUAT.SoLuong = 5;
            }
            if (ModelState.IsValid)
            {
                string str = "";
                string nv = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == dONHANGXUAT.MaNV).Hoten;
                string dl = db.DAILies.AsNoTracking().FirstOrDefault(x => x.MaDL == dONHANGXUAT.MaDaiLy).Ten;

                // Insert DONHANGXUAT
                dONHANGXUAT.isXoa = false;
                dONHANGXUAT.TrangThai = false;
                db.DONHANGXUATs.Add(dONHANGXUAT);
                db.SaveChanges();
                int id = dONHANGXUAT.MaDHX;
                str += "<b>Mã DHX: </b> " + id + "</br>";
                str += "<b>Nhân Viên: </b> " + nv + "</br>";
                str += "<b>Đại Lý: </b> " + dl + "</br>";
                str += "<b>Thời Gian: </b> " + dONHANGXUAT.ThoiGian + "</br>";
                str += "<b>Phương Tiện: </b> " + dONHANGXUAT.PhuongTien + "</br>";
                str += "------------------</br>";

                // Insert CHITIETDONHANGXUAT
                foreach (string maSP in dONHANGXUAT.MaSP)
                {
                    CHITIETDONHANGXUAT ct = new CHITIETDONHANGXUAT();
                    int masp = int.Parse(maSP);
                    string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == masp).TenSP;

                    ct.MaDHX = id;
                    ct.MaSP = masp;
                    ct.SoLuong = dONHANGXUAT.SoLuong;
                    ct.isXoa = false;
                    db.CHITIETDONHANGXUATs.Add(ct);
                    db.SaveChanges();

                    str += "<b>Sản Phẩm:</b> " + sp + "</br>";
                    str += "<b>Số Lượng:</b> " + dONHANGXUAT.SoLuong + "</br>";
                    str += "------------------</br>";
                }

                str += "--------- Lưu Vết ---------</br>";
                
                // Insert LuuViet
                LUUVET luuVet = new LUUVET();
                luuVet.isXoa = false;
                luuVet.MaDHX = id;
                luuVet.MaNV = int.Parse(dONHANGXUAT.MaNV+ "");
                luuVet.MaTram = dONHANGXUAT.Tram;
                luuVet.TrangThai = false;
                db.LUUVETs.Add(luuVet);
                db.SaveChanges();

                string tram = db.TRAMs.AsNoTracking().FirstOrDefault(x => x.MaTram == dONHANGXUAT.Tram).TenTram;
                str += "<b>Mã DHX :</b>" + id + "</br>";
                str += "<b>Nhân Viên :</b>" + nv + "</br>";
                str += "<b>Trạm :</b>" + tram + "</br>";
                ghiLog.AddNewGhiLog("Thêm mới", Session["username"] + "", str, "Đơn Hàng Xuất");

                ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
                ViewBag.ListDaiLy = db.DAILies.Where(x => x.isXoa == false).ToList();
                ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
                return RedirectToAction("Index");
            }

            return View(dONHANGXUAT);
        }

        // GET: DONHANGXUATs/Edit/5
        public ActionResult Edit(int? id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            DONHANGXUAT dONHANGXUAT = db.DONHANGXUATs.Where(x => x.MaDHX == id && x.isXoa == false).First();
            if (dONHANGXUAT == null)
            {
                return HttpNotFound();
            }

            List<CHITIETDONHANGXUAT> ct = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == dONHANGXUAT.MaDHX && x.isXoa == false).ToList();
            
            ViewBag.SoLuong = ct.First().SoLuong;
            ViewBag.SanPhamNhap = string.Join(",", ct.Select(x => x.MaSP).ToArray());

            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListDaiLy = db.DAILies.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListTram = db.TRAMs.Where(x => x.isXoa == false).ToList();
            ViewBag.CurrentTram = db.LUUVETs.FirstOrDefault(x => x.MaDHX == dONHANGXUAT.MaDHX).MaTram;
            HiddenMenu();
            return View(dONHANGXUAT);
        }

        // POST: DONHANGXUATs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaDHX,MaDaiLy,MaNV,SoLuong,MaSP,TrangThai,isXoa,Tram,ThoiGian,PhuongTien")] DONHANGXUAT dONHANGXUAT)
        {
            if (ModelState.IsValid)
            {
                string str = "<b>Mã DHX: </b>" + dONHANGXUAT.MaDHX + "</br>";
                DONHANGXUAT dhxCu = db.DONHANGXUATs.AsNoTracking().FirstOrDefault(x => x.MaDHX == dONHANGXUAT.MaDHX);
                LUUVET lv = db.LUUVETs.FirstOrDefault(x => x.MaDHX + "" == dONHANGXUAT.MaDHX+"");
                bool isUpdate = false;
                if (dhxCu.MaNV != dONHANGXUAT.MaNV)
                {
                    string nvCu = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == dhxCu.MaNV).Hoten;
                    string nvMoi = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == dONHANGXUAT.MaNV).Hoten;
                    str += "<b>Nhân Viên: </b>" + nvCu +" => " + nvMoi + "</br>";
                    isUpdate = true;
                    lv.MaNV = int.Parse(dONHANGXUAT.MaNV + "");
                }

                if (dhxCu.MaDaiLy != dONHANGXUAT.MaDaiLy)
                {
                    string dlCu = db.DAILies.AsNoTracking().FirstOrDefault(x => x.MaDL == dhxCu.MaDaiLy).Ten;
                    string dlMoi = db.DAILies.AsNoTracking().FirstOrDefault(x => x.MaDL == dONHANGXUAT.MaDaiLy).Ten;
                    str += "<b>Đại Lý: </b>" + dlCu + " => " + dlMoi + "</br>";
                }

                if (dhxCu.ThoiGian != dONHANGXUAT.ThoiGian)
                {
                    str += "<b>Thời Gian: </b>" + dhxCu.ThoiGian + " => " + dONHANGXUAT.ThoiGian + "</br>";
                }

                if (dhxCu.PhuongTien != dONHANGXUAT.PhuongTien)
                {
                    str += "<b>Phương Tiện: </b>" + dhxCu.PhuongTien + " => " + dONHANGXUAT.PhuongTien + "</br>";
                }

                if (dONHANGXUAT.Tram != lv.MaTram)
                {
                    string tramCu = db.TRAMs.AsNoTracking().FirstOrDefault(x => x.MaTram == lv.MaTram).TenTram;
                    string tramMoi = db.TRAMs.AsNoTracking().FirstOrDefault(x => x.MaTram == dONHANGXUAT.Tram).TenTram;
                    str += "<b>Trạm: </b>" + tramCu + " => " + tramMoi + "</br>";
                    isUpdate = true;
                    lv.MaTram = dONHANGXUAT.Tram;
                }
                if (isUpdate)
                {
                    db.Entry(lv).State = EntityState.Modified;
                }
                dONHANGXUAT.isXoa = false;
                if (dONHANGXUAT.TrangThai == null) dONHANGXUAT.TrangThai = false;
                db.Entry(dONHANGXUAT).State = EntityState.Modified;
                db.SaveChanges();
                str += "------------------</br>";

                List<CHITIETDONHANGXUAT> ct = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == dONHANGXUAT.MaDHX).ToList();

                List<string> maSpDelete = ct.Select(x => x.MaSP + "").ToArray().Except(dONHANGXUAT.MaSP).ToList();
                foreach (string item in maSpDelete)
                {
                    CHITIETDONHANGXUAT itemDelete = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == dONHANGXUAT.MaDHX && x.MaSP + "" == item).First();
                    if (itemDelete != null && !(bool)itemDelete.isXoa)
                    {
                        itemDelete.isXoa = true;
                        db.Entry(itemDelete).State = EntityState.Modified;
                        db.SaveChanges();
                        string tensp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP + "" == item).TenSP;
                        str += "Sản Phẩm <b>"+ tensp + "</b> Đã bị xóa.</br>";
                    }
                }

                string addNewstr = "--------Thêm Mới---------</br>";
                string restoreSP = "--------Sửa----------</br>";
                foreach (string msp in dONHANGXUAT.MaSP)
                {
                    int id = int.Parse(msp);
                    CHITIETDONHANGXUAT addNew = db.CHITIETDONHANGXUATs.FirstOrDefault(x => x.MaDHX == dONHANGXUAT.MaDHX && x.MaSP == id);
                    string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == id).TenSP;

                    if (addNew == null)
                    {
                        addNew = new CHITIETDONHANGXUAT();
                        addNew.isXoa = false;
                        addNew.MaDHX = dONHANGXUAT.MaDHX;
                        addNew.MaSP = id;
                        addNew.SoLuong = dONHANGXUAT.SoLuong;
                        db.CHITIETDONHANGXUATs.Add(addNew);
                        db.SaveChanges();

                        addNewstr += "<b>Sản Phẩm:</b> " + sp + "</br>";
                        addNewstr += "<b>Số Lượng:</b> " + dONHANGXUAT.SoLuong + "</br>";
                        addNewstr += "------------------</br>";
                    }
                    else
                    {
                        if ((bool)addNew.isXoa)
                        {
                            addNew.isXoa = false;
                        }
                        addNew.SoLuong = dONHANGXUAT.SoLuong;
                        db.Entry(addNew).State = EntityState.Modified;
                        db.SaveChanges();

                        restoreSP += "<b>Sản Phẩm:</b> " + sp + "</br>";
                        restoreSP += "<b>Số Lượng:</b> " + addNew.SoLuong + " => " + dONHANGXUAT.SoLuong + "</br>";
                    }

                }
                ghiLog.AddNewGhiLog("Sửa", Session["username"] + "", str + addNewstr + restoreSP, "Đơn Hàng Xuất");
                return RedirectToAction("Index");
            }
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListDaiLy = db.DAILies.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            return View(dONHANGXUAT);
        }


        public ActionResult Delete(int id)
        {
            string str = "";
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            DONHANGXUAT dONHANGXUAT = db.DONHANGXUATs.Where(x => x.MaDHX == id).First();
            if (dONHANGXUAT == null)
            {
                return HttpNotFound();
            }

            dONHANGXUAT.isXoa = false;
            db.Entry(dONHANGXUAT).State = EntityState.Modified;
            db.SaveChanges();
            str += "<b>Đã xóa đơn hàng xuất: </b>" + dONHANGXUAT.MaDHX + "</br>";
            ghiLog.AddNewGhiLog("Xóa",Session["username"]+"",str,"Đơn Hàng Xuất");
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
