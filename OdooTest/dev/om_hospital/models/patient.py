from odoo import api, fields, models

class HospitalPatient(models.Model):
    _name = "hospital.patient"

    name = fields.Char(string='Name', required=True)
