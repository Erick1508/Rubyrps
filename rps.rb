# El programa consiste en el juego tradicional de 
# piedra papel o tijeras, y se definen estrategias
# para elegir el proximo movimiento de los jugadores
#
# Author :: Juan Pereria 09-11173 y Erick Marrero 09-10981

# Esta clase representa el movimiento que se va a jugar
class Movement
  attr_reader :move
  #Inicializa en el movimiento a jugar
  def initialize(move)
    @move = move
  end  
  #Aplica to_s a los atributos
  def to_s
    @move.to_s
  end  
  
end

#Esta clase es subclase hereda de Movement
class Rock < Movement
  #Inicializa la clase Rock
  def initialize(move='rock')
    super(move)
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score m
    m.score_Rock self
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Rock m
    [0,0]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Paper m
    [1,0]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Scissors m
    [0,1]
  end
end

#Esta clase es subclase hereda de Movement
class Paper < Movement
  #Inicializa la clase Paper
  def initialize(move='paper')
    super(move)
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score m
    m.score_Paper self
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Paper m
    [0,0]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Rock m
    [0,1]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Scissors m
    [1,0]
  end

end

#Esta clase es subclase hereda de Movement
class Scissors < Movement
  #Inicializa la clase Scissors
  def initialize(move='scissor')
    super(move)
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score m
    m.score_Scissors self
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Scissors m
    [0,0]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Paper m
    [0,1]
  end
  #Devuelve el resultado en una tupla usando despacho doble
  def score_Rock m
    [1,0]
  end
end

#Esta Clase es a que decidirá el movimiento del jugador en cada ronda
class Strategy
  #Constante SEMILLA para hacer los numeros aleatorios
  SEMILLA = 42
  attr_reader :gamer
  #Inicializa el nombre del jugador
  def initialize name
    @gamer = name
  end
  #Aplica to_s a los atributos
  def to_s
    @gamer.to_s
  end  
end
#Esta clase es subclase de Strategy
#y consiste en elegir el movimiento de manera uniforme siempre
class Uniform < Strategy
  attr_reader :list, :reallist
  #Inicializa list en la lista de los movimientos a seguir y
  #reallist guarda la lista original
  def initialize (lista,reallist=lista)
    if lista.length == 0 then
      raise "La lista NO puede ser vacia"
    else
      @list = lista.uniq
      @reallist = @list.clone
    end     
  end
  #Aplica to_s a los atributos
  def to_s 
    @list.each do |name|
      name.to_s
    end
  end
  #Devuelve un objeto de la clase Movement
  def next (m=nil)
    first = @list.shift
    @list.push(first)
    first    
  end
  #Deja todo como en su estado inicial
  def reset
    @list = @reallist
  end      
end  

#Esta clase es subclase de Strategy
#y consiste en hacer una distribución sesgada con 
#respecto a su probabilidad
class Biased < Strategy
  attr_reader :probs, :arreglo
  #Inicializa probs en un Hash con una instancia de Movement con su probabilidad
  #y se se guarda en arreglo
  def initialize probabilidades
    if probabilidades.empty? then
      raise "Debe existir al menos un elemento"
    else
      srand(SEMILLA)
      @probs = Hash.new
      @probs = probabilidades
      self.calcular_probs
      @arreglo = @probs.values

    end
  end
  #Aplica to_s a los atributos
  def to_s 
    @probs.each_pair do |key, value|
    end
  end
  #Calcula las probabilidades
  def calcular_probs
    var = 0
    @probs.each_pair do |key, value|
       var = var + value
    end
    if var > 0 
      @probs.each_pair do |key, value|
	@probs[key] = value / var.to_f
      end
    end    
  end  
  #Devuelve un objeto de la clase Movement
  def next(m=nil)
    numalea = rand
    @arreglo = @arreglo.sort
    tam = @arreglo.length
    cont = 0
    aux3 = 0
    bool = true
    while cont < tam  do       
      if bool then
	aux1 = 0
	aux2 = @arreglo[cont]
	bool = false
      else
	aux1 = @arreglo[cont-1]
	aux2 = @arreglo[cont]
      end
      if (aux1 <= numalea) and (numalea< aux2) then
	return @probs.key (@arreglo[cont])
      end
      cont += 1      
    end
    @probs.key (@arreglo[tam-1])
  end
  #Deja todo como en su estado inicial
  def reset 
    srand(SEMILLA)
  end      
end  
#Esta clase es subclase de Strategy
#y consiste en jugar siempre lo que el contrincante
#eligió en la jugada anterior, salvo la primera mano 
#que devuelve el movimiento con el que fue creado
class Mirror < Strategy
  attr_reader :mov
  #Inicializa mov en move
  def initialize move
    @mov = move
  end
  #Devuelve un objeto de la clase Movement
  def next(m=nil)
    if m != nil then
      m
    else 
      @mov
    end   
  end
  #Aplica to_s a los atributos
  def to_s
    @mov.to_s
  end
  #Deja todo como en su estado inicial
  def reset
    @mov = @mov
  end
end
#Esta clase es subclase de Strategy
#y consiste en elegir el movimiento en base a las jugadas anteriores
#del contrincante
class Smart < Strategy
  attr_reader :p, :r, :s
  #Inicializa todo en cero
  def initialize    
    srand(SEMILLA)
    @p = 0
    @r = 0
    @s = 0
  end
  #Aplica to_s a los atributos
  def to_s
    ans = @p.to_s + " "+ @r.to_s+ " "+ @s.to_s
  end
  #Aumenta los atributos según sea el objeto m
  def aumentar m
    if m.class == Rock then
      @r = @r +1
    elsif m.class == Paper then
      @p = @p +1
    elsif m.class == Scissors then
      @s = @s +1
    end
  end
  #Devuelve un objeto de la clase Movement
  def next (m=nil)
    if m != nil then
      self.aumentar(m)
    end  
    
    suma = @p + @s + @r
    
    if suma == 0 then
      return Scissors.new
    end
    numalea = rand(suma-1)
    if (0 <= numalea) and (numalea< @p) then
      return Scissors.new
    elsif (@p <= numalea) and (numalea < (@p + @r)) then
      return Paper.new
    elsif (@p + @r) <= numalea and (numalea < (@p + @r +@s)) then
      return Rock.new      
    end  
    
  end 
  #Deja todo como en su estado inicial
  def reset
    srand(SEMILLA)
    @p = 0
    @r = 0
    @s = 0    
  end

end

#Esta clase es el juego del programa
class Match 
  attr_reader :mapa, :ronda
  #Inicializa con exactamente 2 jugadores y unas estrategias bien definidas
  #almacenados en un hash
  def initialize (mapa,ronda={})
    if mapa.empty? then
      raise "No puede ser vacio "
    else
      if mapa.length == 2 then
	if self.chequeo(mapa.values[0]) and
	   self.chequeo(mapa.values[1]) then
	      @mapa = Hash.new
	      @ronda = Hash.new
	      @ronda = {"0"=> 0,"1" => 0,"Rondas" =>0}
	      @mapa = mapa
	else
	  raise "No esta definida al menos una estrategia"
	end
      else
	raise "No hay 2 jugadores exactos"
      end
    end
  end
  #Aplica to_s a los atributos
  def to_s
    @mapa.each_pair do |key, value|
    end
  end
  #Chequea que m sea una subclase de Strategy
  def chequeo m
    if m.instance_of? Uniform or m.instance_of? Biased or 
       m.instance_of? Mirror or m.instance_of? Smart
	  return true
    end
    false
  end
  #Aplica las estrategias de cada jugador y lo hace n veces para devolver
  #los resultados en un hash
  def rounds n
    rondas = n
    ptsacum1 = 0
    ptsacum2 = 0
    mov1,mov2 = nil,nil
    while n != 0 do
      mov1,mov2 = @mapa.values[0].next(mov2),@mapa.values[1].next(mov1)
      puntos = mov1.score(mov2)
      ptsacum1 += puntos[0]
      ptsacum2 += puntos[1]
      n = n-1
    end
    ptsacum1 += @ronda.values[0]
    ptsacum2 += @ronda.values[1]
    rondas += @ronda.values[2]  
    @ronda = {@mapa.keys[0] => ptsacum1, @mapa.keys[1] => ptsacum2, "Rondas" => rondas}
    
  end
  #Aplica las estrategias de cada jugador y lo hace hasta que un
  #jugador llegue a n puntos y devuelve
  #los resultados en un hash
  def upto n
    rondas = 0
    ptsacum1 = @ronda.values[0]
    ptsacum2 = @ronda.values[1]
    rondasaux = 0
    if n <= ptsacum1 or n <= ptsacum2 then
      return "Uno de los jugadores ya supero esta puntuacion o es igual a la misma"
    end  
    while n > ptsacum1 and n > ptsacum2 do
      mov1,mov2 = @mapa.values[0].next(mov2),@mapa.values[1].next(mov1)
      puntos = mov1.score(mov2)
      ptsacum1 += puntos[0]
      ptsacum2 += puntos[1]
      rondasaux += 1
    end
    rondasaux += @ronda.values[2]
    @ronda = {@mapa.keys[0] => ptsacum1, @mapa.keys[1] => ptsacum2, "Rondas" => rondasaux}
    
  end
  #Lleva el juego a su estado inicial
  def restart
    @mapa.values[0].reset
    @mapa.values[1].reset
    @ronda = {"0"=> 0,"1" => 0,"Rondas" =>0}
    "Juego Reiniciado"
  end
  
end  
  
  