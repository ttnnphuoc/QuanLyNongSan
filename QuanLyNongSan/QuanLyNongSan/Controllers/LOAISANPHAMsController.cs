using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using QuanLyNongSan.Models;

namespace QuanLyNongSan.Controllers
{
    public class LOAISANPHAMsController : Controller
    {
        private QLCUNGUNGEntities db = new QLCUNGUNGEntities();

        // GET: LOAISANPHAMs
        public ActionResult Index()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            ViewBag.IsAdmin = "hidden-menu";
            ViewBag.Add = "disable-btn";
            if (isAdmin(Session["username"] + ""))
            {
                ViewBag.Add = "";
                ViewBag.IsAdmin = "";
            }
            return View(db.LOAISANPHAMs.Where(x=>x.isXoa == false).ToList());
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
        // GET: LOAISANPHAMs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            LOAISANPHAM lOAISANPHAM = db.LOAISANPHAMs.Find(id);
            if (lOAISANPHAM == null)
            {
                return HttpNotFound();
            }
            return View(lOAISANPHAM);
        }

        // GET: LOAISANPHAMs/Create
        public ActionResult Create()
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            return View();
        }

        // POST: LOAISANPHAMs/Create
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "MaLoai,TenLoai,isXoa")] LOAISANPHAM lOAISANPHAM)
        {
            if (ModelState.IsValid)
            {
                lOAISANPHAM.isXoa = false;
                db.LOAISANPHAMs.Add(lOAISANPHAM);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(lOAISANPHAM);
        }

        // GET: LOAISANPHAMs/Edit/5
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
            LOAISANPHAM lOAISANPHAM = db.LOAISANPHAMs.Find(id);
            if (lOAISANPHAM == null)
            {
                return HttpNotFound();
            }
            return View(lOAISANPHAM);
        }

        // POST: LOAISANPHAMs/Edit/5
        // To protect from overposting attacks, please enable the specific properties you want to bind to, for 
        // more details see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "MaLoai,TenLoai,isXoa")] LOAISANPHAM lOAISANPHAM)
        {
            if (ModelState.IsValid)
            {
                lOAISANPHAM.isXoa = false;
                db.Entry(lOAISANPHAM).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(lOAISANPHAM);
        }

        // GET: LOAISANPHAMs/Delete/5
        //public ActionResult Delete(int? id)
        //{
        //    if (id == null)
        //    {
        //        return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
        //    }
        //    LOAISANPHAM lOAISANPHAM = db.LOAISANPHAMs.Find(id);
        //    if (lOAISANPHAM == null)
        //    {
        //        return HttpNotFound();
        //    }
        //    return View(lOAISANPHAM);
        //}

        public ActionResult Delete(int id)
        {
            if (Session["username"] == null)
            {
                return RedirectToAction("Login", "TaiKhoans");
            }
            LOAISANPHAM lOAISANPHAM = db.LOAISANPHAMs.Find(id);
            if (lOAISANPHAM == null)
            {
                return HttpNotFound();
            }
            lOAISANPHAM.isXoa = true;
            db.Entry(lOAISANPHAM).State = EntityState.Modified;
            db.SaveChanges();
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
