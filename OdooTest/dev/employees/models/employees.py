from odoo import api, fields, models

class Employees(models.Model):
    _name = "employees.employees"
    _description = 'Employees'

    name = fields.Char(string = 'Name', required = True)
    position = fields.Char(string = 'Position', required = True)

