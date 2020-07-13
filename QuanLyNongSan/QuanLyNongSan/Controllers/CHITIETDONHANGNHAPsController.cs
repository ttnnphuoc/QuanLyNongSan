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
    public class CHITIETDONHANGNHAPsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private GhiLog ghiLog = new GhiLog();

        // GET: CHITIETDONHANGNHAPs
        public ActionResult Index()
        {
            return View(db.CHITIETDONHANGNHAPs.ToList());
        }

        // GET: CHITIETDONHANGNHAPs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETDONHANGNHAP cHITIETDONHANGNHAP = db.CHITIETDONHANGNHAPs.Find(id);
            if (cHITIETDONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            return View(cHITIETDONHANGNHAP);
        }

        // GET: CHITIETDONHANGNHAPs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CHITIETDONHANGNHAPs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDHN,MaSP,SoLuong,TrangThai,isXoa")] CHITIETDONHANGNHAP cHITIETDONHANGNHAP)
        {
            if (ModelState.IsValid)
            {
                db.CHITIETDONHANGNHAPs.Add(cHITIETDONHANGNHAP);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(cHITIETDONHANGNHAP);
        }

        // GET: CHITIETDONHANGNHAPs/Edit/5
        public ActionResult Edit(int? id, int? MaSP)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETDONHANGNHAP cHITIETDONHANGNHAP = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == id && x.MaSP == MaSP).First();
            if (cHITIETDONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            ViewBag.TenSanPham = db.SANPHAMs.Where(x => x.isXoa == false && cHITIETDONHANGNHAP.MaSP == x.MaSP).First().TenSP;
            return View(cHITIETDONHANGNHAP);
        }

        // POST: CHITIETDONHANGNHAPs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaDHN,MaSP,SoLuong,TrangThai,isXoa")] CHITIETDONHANGNHAP cHITIETDONHANGNHAP)
        {
            string str = "";
            if (ModelState.IsValid)
            {
                CHITIETDONHANGNHAP ct = db.CHITIETDONHANGNHAPs.AsNoTracking().First(x => x.MaSP == cHITIETDONHANGNHAP.MaSP && x.MaDHN == cHITIETDONHANGNHAP.MaDHN);
                string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == cHITIETDONHANGNHAP.MaSP).TenSP;
                str += "<b>Sản Phẩm: </b>" + sp + "</br>";
                str += "<b>Số Lượng: </b>" + ct.SoLuong + " => " + cHITIETDONHANGNHAP.SoLuong + "</br>";
                str += "<b>Trạng Thái: </b>" + ct.TrangThai +" => " + cHITIETDONHANGNHAP.TrangThai + "</br>";
                cHITIETDONHANGNHAP.isXoa = false;
                db.Entry(cHITIETDONHANGNHAP).State = EntityState.Modified;
                db.SaveChanges();
                ghiLog.AddNewGhiLog("Sửa", Session["username"] + "", str, "Chi Tiết Đơn Hàng Nhập");

                return RedirectToAction("Details", "DonHangNhaps",new { id = cHITIETDONHANGNHAP.MaDHN});
            }
            return View(cHITIETDONHANGNHAP);
        }

        // GET: CHITIETDONHANGNHAPs/Delete/5
        public ActionResult Delete(int? id, int? MaSP)
        {

            CHITIETDONHANGNHAP cHITIETDONHANGNHAP = db.CHITIETDONHANGNHAPs.Where(x => x.MaDHN == id && x.MaSP == MaSP).First();
            if (cHITIETDONHANGNHAP == null)
            {
                return HttpNotFound();
            }
            cHITIETDONHANGNHAP.isXoa = true;
            db.Entry(cHITIETDONHANGNHAP).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Details", "DonHangNhaps", new { id = cHITIETDONHANGNHAP.MaDHN });
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
