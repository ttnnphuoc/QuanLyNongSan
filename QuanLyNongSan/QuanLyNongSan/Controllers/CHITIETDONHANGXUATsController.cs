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
    public class CHITIETDONHANGXUATsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();
        private GhiLog ghiLog = new GhiLog();
        // GET: CHITIETDONHANGXUATs
        public ActionResult Index()
        {
            return View(db.CHITIETDONHANGXUATs.ToList());
        }

        // GET: CHITIETDONHANGXUATs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETDONHANGXUAT cHITIETDONHANGXUAT = db.CHITIETDONHANGXUATs.Find(id);
            if (cHITIETDONHANGXUAT == null)
            {
                return HttpNotFound();
            }
            return View(cHITIETDONHANGXUAT);
        }

        // GET: CHITIETDONHANGXUATs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: CHITIETDONHANGXUATs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaDHX,MaSP,SoLuong,isXoa")] CHITIETDONHANGXUAT cHITIETDONHANGXUAT)
        {
            if (ModelState.IsValid)
            {
                db.CHITIETDONHANGXUATs.Add(cHITIETDONHANGXUAT);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(cHITIETDONHANGXUAT);
        }

        // GET: CHITIETDONHANGXUATs/Edit/5
        public ActionResult Edit(int? id, int? MaSP)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            CHITIETDONHANGXUAT cHITIETDONHANGXUAT = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == id && x.MaSP == MaSP).First();
            if (cHITIETDONHANGXUAT == null)
            {
                return HttpNotFound();
            }
            ViewBag.TenSanPham = db.SANPHAMs.Where(x => x.isXoa == false && cHITIETDONHANGXUAT.MaSP == x.MaSP).First().TenSP;
            return View(cHITIETDONHANGXUAT);
        }

        // POST: CHITIETDONHANGXUATs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaDHX,MaSP,SoLuong,isXoa")] CHITIETDONHANGXUAT cHITIETDONHANGXUAT)
        {
            string str = "";
            if (ModelState.IsValid)
            {
                CHITIETDONHANGXUAT ct = db.CHITIETDONHANGXUATs.AsNoTracking().First(x => x.MaSP == cHITIETDONHANGXUAT.MaSP && x.MaDHX == cHITIETDONHANGXUAT.MaDHX);
                string sp = db.SANPHAMs.AsNoTracking().FirstOrDefault(x => x.MaSP == cHITIETDONHANGXUAT.MaSP).TenSP;
                str += "<b>Sản Phẩm: </b>" + sp + "</br>";
                str += "<b>Số Lượng: </b>" + ct.SoLuong +" => "+cHITIETDONHANGXUAT.SoLuong + "</br>";
                cHITIETDONHANGXUAT.isXoa = false;
                db.Entry(cHITIETDONHANGXUAT).State = EntityState.Modified;
                db.SaveChanges();

                ghiLog.AddNewGhiLog("Sửa", Session["username"] + "", str, "Chi Tiết Đơn Hàng Xuất");
                return RedirectToAction("Details", "DonHangXuats",new { id = cHITIETDONHANGXUAT.MaDHX});
            }
            return View(cHITIETDONHANGXUAT);
        }

        // GET: CHITIETDONHANGXUATs/Edit/5
        public ActionResult Delete(int? id, int? MaSP)
        {
            CHITIETDONHANGXUAT cHITIETDONHANGXUAT = db.CHITIETDONHANGXUATs.Where(x => x.MaDHX == id && x.MaSP == MaSP).First();
            if (cHITIETDONHANGXUAT == null)
            {
                return HttpNotFound();
            }
            cHITIETDONHANGXUAT.isXoa = true;
            db.Entry(cHITIETDONHANGXUAT).State = EntityState.Modified;
            db.SaveChanges();
            return RedirectToAction("Details", "DonHangXuats", new { id = cHITIETDONHANGXUAT.MaDHX });
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
