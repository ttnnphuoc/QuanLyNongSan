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
    public class DONHANGNHAPsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private GhiLog ghiLog = new GhiLog();
        // GET: DONHANGNHAPs
        public ActionResult Index()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }

            HiddenMenu();
            ViewBag.NhanVien = db.NHANVIENs.Where(x=>x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            return View(db.DONHANGNHAPs.Where(x=>x.isXoa == false).ToList());
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
        // GET: DONHANGNHAPs/Details/5
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
            DONHANGNHAP dONHANGNHAP = db.DONHANGNHAPs.Where(x=>x.MaDHN == id && x.isXoa == false).First();
            if (dONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            List<CHITIETDONHANGNHAP> listChiTietDonHang = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == dONHANGNHAP.MaDHN && x.isXoa == false).ToList();

            ViewBag.ChiTietDonHangNhap = listChiTietDonHang;

            List<SANPHAM> listSanPham = new List<SANPHAM>();
            foreach(CHITIETDONHANGNHAP item in listChiTietDonHang)
            {
                listSanPham.Add(db.SANPHAMs.FirstOrDefault(x => x.MaSP == item.MaSP && x.isXoa == false));
            }
            ViewBag.ListSanPham = listSanPham;
            HiddenMenu();
            return View(dONHANGNHAP);
        }

        // GET: DONHANGNHAPs/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            return View();
        }

        // POST: DONHANGNHAPs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDHN,MaNhaCC,NgayNhap,MaNV,isXoa,MaSP,SoLuong,ThoiGian,PhuongTien")] DONHANGNHAP dONHANGNHAP)
        {
            if (ModelState.IsValid)
            {
                dONHANGNHAP.isXoa = false;
                db.DONHANGNHAPs.Add(dONHANGNHAP);
                db.SaveChanges();
                int id = dONHANGNHAP.MaDHN;

                string ncc = db.NHACUNGCAPs.AsNoTracking().FirstOrDefault(x => x.MaNCC == dONHANGNHAP.MaNhaCC).TenNhaCC;
                string nv = db.NHANVIENs.AsNoTracking().FirstOrDefault(x =>x.MaNV == dONHANGNHAP.MaNV).Hoten;
                string str = "<b>Mã DHN:</b> " + id + "</br>";
                str += "<b>Nhà Cung Cấp:</b> " + ncc + "</br>";
                str += "<b>Ngày Nhập:</b> " + Convert.ToDateTime(dONHANGNHAP.NgayNhap).ToString("dd/MM/yyyy") +"</br>";
                str += "<b>Nhân Viên:</b> " + nv + "</br>";
                str += "------------------</br>";
                foreach (string maSP in dONHANGNHAP.MaSP)
                {
                    CHITIETDONHANGNHAP ct = new CHITIETDONHANGNHAP();
                    int masp = int.Parse(maSP);
                    string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == masp).TenSP;
                    ct.MaDHN = id;
                    ct.MaSP = masp;
                    ct.SoLuong = dONHANGNHAP.SoLuong;
                    ct.TrangThai = null;
                    ct.isXoa = false;
                    db.CHITIETDONHANGNHAPs.Add(ct);
                    db.SaveChanges();
                    str += "<b>Sản Phẩm:</b> " + sp + "</br>";
                    str += "<b>Số Lượng:</b> " + dONHANGNHAP.SoLuong + "</br>";
                    str += "------------------</br>";
                }
                ghiLog.AddNewGhiLog("Thêm mới", Session["username"] + "", str, "Đơn Hàng Nhập");
                return RedirectToAction("Index");
            }

            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            return View(dONHANGNHAP);
        }


        // GET: DONHANGNHAPs/Edit/5
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
            DONHANGNHAP dONHANGNHAP = db.DONHANGNHAPs.Where(x => x.MaDHN == id).First();
            if (dONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            List<CHITIETDONHANGNHAP> ct = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == dONHANGNHAP.MaDHN && x.isXoa == false).ToList();
            ViewBag.SoLuong = ct.First().SoLuong;
            ViewBag.SanPhamNhap = string.Join(",",ct.Select(x => x.MaSP).ToArray());
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            return View(dONHANGNHAP);
        }

        // POST: DONHANGNHAPs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaDHN,MaNhaCC,NgayNhap,MaNV,isXoa,MaSP,SoLuong,ThoiGian,PhuongTien")] DONHANGNHAP dONHANGNHAP)
        {
            if (ModelState.IsValid)
            {
                string str = "<b>Mã DHX: </b>" + dONHANGNHAP.MaDHN + "</br>";
                DONHANGNHAP dhnCu = db.DONHANGNHAPs.AsNoTracking().FirstOrDefault(x => x.MaDHN == dONHANGNHAP.MaDHN);
                if (dhnCu.NgayNhap != dONHANGNHAP.NgayNhap)
                {
                    str += "<b>Ngày Nhập: </b>" + dhnCu.NgayNhap + " => " + dONHANGNHAP.NgayNhap + "</br>";
                }

                if (dhnCu.MaNhaCC != dONHANGNHAP.MaNhaCC)
                {
                    string nccCu = db.NHACUNGCAPs.AsNoTracking().FirstOrDefault(x => x.MaNCC == dhnCu.MaNhaCC).TenNhaCC;
                    string nccMoi = db.NHACUNGCAPs.AsNoTracking().FirstOrDefault(x => x.MaNCC == dONHANGNHAP.MaNhaCC).TenNhaCC;
                    str += "<b>Nhà Cung Cấp: </b>" + nccCu + " => " + nccMoi + "</br>";
                }

                if (dhnCu.MaNV != dONHANGNHAP.MaNV)
                {
                    string nvCu = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == dhnCu.MaNV).Hoten;
                    string nvMoi = db.NHANVIENs.AsNoTracking().FirstOrDefault(x => x.MaNV == dONHANGNHAP.MaNV).Hoten;
                    str += "<b>Nhân Viên: </b>" + nvCu + " => " + nvMoi + "</br>";
                }

                if (dhnCu.ThoiGian != dONHANGNHAP.ThoiGian)
                {
                    str += "<b>Thời Gian: </b>" + dhnCu.ThoiGian + " => " + dONHANGNHAP.ThoiGian + "</br>";
                }

                if (dhnCu.PhuongTien != dONHANGNHAP.PhuongTien)
                {
                    str += "<b>Phương Tiện: </b>" + dhnCu.PhuongTien + " => " + dONHANGNHAP.PhuongTien + "</br>";
                }
                dONHANGNHAP.isXoa = false;
                db.Entry(dONHANGNHAP).State = EntityState.Modified;
                db.SaveChanges();
                str += "------------------</br>";

                List<CHITIETDONHANGNHAP> ct = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == dONHANGNHAP.MaDHN).ToList();

                List<string> maSpDelete = ct.Select(x => x.MaSP + "").ToArray().Except(dONHANGNHAP.MaSP).ToList();
                foreach (string item in maSpDelete)
                {
                    CHITIETDONHANGNHAP itemDelete = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == dONHANGNHAP.MaDHN && x.MaSP + "" == item).First();
                    if (itemDelete != null && !(bool)itemDelete.isXoa)
                    {
                        itemDelete.isXoa = true;
                        db.Entry(itemDelete).State = EntityState.Modified;
                        db.SaveChanges();
                        string tensp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP + "" == item).TenSP;
                        str += "Sản Phẩm <b>" + tensp + "</b> Đã bị xóa.</br>";

                    }
                }

                string addNewstr = "--------Thêm Mới---------</br>";
                string restoreSP = "--------Sửa----------</br>";

                foreach (string msp in dONHANGNHAP.MaSP)
                {
                    int id = int.Parse(msp);
                    CHITIETDONHANGNHAP addNew = db.CHITIETDONHANGNHAPs.FirstOrDefault(x => x.MaDHN == dONHANGNHAP.MaDHN && x.MaSP == id);
                    string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == id).TenSP;

                    if (addNew == null)
                    {
                        addNew = new CHITIETDONHANGNHAP();
                        addNew.isXoa = false;
                        addNew.MaDHN = dONHANGNHAP.MaDHN;
                        addNew.MaSP = id;
                        addNew.TrangThai = null;
                        addNew.SoLuong = dONHANGNHAP.SoLuong;
                        db.CHITIETDONHANGNHAPs.Add(addNew);
                        db.SaveChanges();

                        addNewstr += "<b>Sản Phẩm:</b> " + sp + "</br>";
                        addNewstr += "<b>Số Lượng:</b> " + dONHANGNHAP.SoLuong + "</br>";
                        addNewstr += "------------------</br>";
                    }
                    else
                    {
                        if ((bool)addNew.isXoa)
                        {
                            addNew.isXoa = false;
                        }
                        addNew.SoLuong = dONHANGNHAP.SoLuong;
                        db.Entry(addNew).State = EntityState.Modified;
                        db.SaveChanges();
                        restoreSP += "<b>Sản Phẩm:</b> " + sp + "</br>";
                        restoreSP += "<b>Số Lượng:</b> " + addNew.SoLuong + " => " + dONHANGNHAP.SoLuong + "</br>";
                    }

                }
                ghiLog.AddNewGhiLog("Sửa", Session["username"] + "", str + addNewstr + restoreSP, "Đơn Hàng Nhập");
                return RedirectToAction("Index");
            }
            ViewBag.NhanVien = db.NHANVIENs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListNCC = db.NHACUNGCAPs.Where(x => x.isXoa == false).ToList();
            ViewBag.ListSP = db.SANPHAMs.Where(x => x.isXoa == false).ToList();
            return View(dONHANGNHAP);
        }

        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            DONHANGNHAP dONHANGNHAP = db.DONHANGNHAPs.Where(x => x.MaDHN == id).First();
            if (dONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            dONHANGNHAP.isXoa = true;
            db.Entry(dONHANGNHAP).State = EntityState.Modified;
            db.SaveChanges();

            string str = "<b>Đã xóa đơn hàng xuất: </b>" + dONHANGNHAP.MaDHN + "</br>";
            ghiLog.AddNewGhiLog("Xóa", Session["username"] + "", str, "Đơn Hàng Xuất");
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
